import Stripe from "stripe";
import { env } from "../config/env";
import pool from "../config/db";
import cuid from 'cuid';


const stripe=new Stripe(env.stripeSecretKey!);
export const createPaymentIntentService=async(amount:number,currency:string,houseID:string,email:string,startDate:string,endDate:string)=>{
  const conflict=await pool.query(`Select booking_id from Bookings where house_id=$1 AND status!='CANCELLED' AND "startDate"<$3 AND "endDate">$2`,[houseID,startDate,endDate]);
  if(conflict.rows.length>0){
    throw new Error("House is already booked for that time period");
  }

    const paymentIntent=await stripe.paymentIntents.create({
        amount:amount*100,
        currency:currency,
        metadata:{houseID,email}
    });
    return {clientsecret:paymentIntent.client_secret}
    
}

export const confirmPaymentAndRentService=async(paymentIntentID:string,houseID:string,email:string,startDate:string,endDate:string)=>{
const stripe=new Stripe(env.stripeSecretKey!);
const paymentIntent=await stripe.paymentIntents.retrieve(paymentIntentID);
if(paymentIntent.status!="succeeded"){
    throw new Error("Payment unsuccessful");
}
 const userResult = await pool.query(
    "SELECT user_id FROM users WHERE email = $1",
    [email]
  );
  if (userResult.rows.length === 0) {
    throw new Error("User not found");
  }
  const tenantId = userResult.rows[0].user_id;

  // Check if already rented
  const existing = await pool.query(
    `SELECT booking_id FROM bookings WHERE tenant_id = $1 AND house_id = $2`,
    [tenantId, houseID]
  );
  if (existing.rows.length > 0) {
    return { message: "Already rented", alreadyRented: true };
  }

  // Create booking
  const bookingId = cuid();
  const booking = await pool.query(
    `INSERT INTO bookings (booking_id, house_id, tenant_id, status,"startDate","endDate") VALUES ($1, $2, $3, 'CONFIRMED',$4,$5) RETURNING *`,
    [bookingId, houseID, tenantId,startDate,endDate]
  );

  // Store payment record
  const paymentId = cuid();
  await pool.query(
    `INSERT INTO payments (payment_id, booking_id, user_id, amount, payment_method, "paymentStatus")
     VALUES ($1, $2, $3, $4, 'CARD', 'SUCCESS')`,
    [paymentId, bookingId, tenantId, paymentIntent.amount / 100]
  );

  return { message: "Payment successful and house rented", alreadyRented: false };
};
export const getBookingStatusService = async (houseID: string) => {
  const result = await pool.query(
    `SELECT "startDate", "endDate" 
     FROM bookings 
     WHERE house_id=$1 AND status='CONFIRMED'
     ORDER BY "startDate" DESC LIMIT 1`,
    [houseID]
  );

  return result.rows[0] || null;
};