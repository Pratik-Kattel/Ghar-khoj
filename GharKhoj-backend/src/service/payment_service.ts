import Stripe from "stripe";
import { env } from "../config/env";
import pool from "../config/db";
import cuid from 'cuid';

const stripe=new Stripe(env.stripeSecretKey!);
export const createPaymentIntentService=async(amount:number,currency:string,houseID:string,email:string)=>{
    const paymentIntent=await stripe.paymentIntents.create({
        amount:amount*100,
        currency:currency,
        metadata:{houseID,email}
    });
    return {clientsecret:paymentIntent.client_secret}
    
}

export const confirmPaymentAndRentService=async(paymentIntentID:string,houseID:string,email:string)=>{
const stripe=new Stripe(env.stripeSecretKey!);
const paymentIntent=await stripe.paymentIntents.retrieve(paymentIntentID);
if(paymentIntent.status!="succeeded"){
    throw new Error("Payment unsuccessful");
}
 const userResult = await pool.query(
    "SELECT user_id FROM users WHERE email = $1",
    [email]
  );
  if (userResult.rows.length === 0) throw new Error("User not found");
  const tenantId = userResult.rows[0].user_id;

  // Check if already rented
  const existing = await pool.query(
    "SELECT booking_id FROM bookings WHERE tenant_id = $1 AND house_id = $2",
    [tenantId, houseID]
  );
  if (existing.rows.length > 0) {
    return { message: "Already rented", alreadyRented: true };
  }

  // Create booking
  const bookingId = cuid();
  const booking = await pool.query(
    "INSERT INTO bookings (booking_id, house_id, tenant_id, status) VALUES ($1, $2, $3, 'CONFIRMED') RETURNING *",
    [bookingId, houseID, tenantId]
  );

  // Store payment record
  const paymentId = cuid();
  await pool.query(
    `INSERT INTO payments (payment_id, booking_id, user_id, amount, payment_method, payment_status)
     VALUES ($1, $2, $3, $4, 'CARD', 'SUCCESS')`,
    [paymentId, bookingId, tenantId, paymentIntent.amount / 100]
  );

  return { message: "Payment successful and house rented", alreadyRented: false };
};