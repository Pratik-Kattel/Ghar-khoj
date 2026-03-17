import pool from "../config/db";
import cuid from "cuid";

export const addToRentsService = async (userEmail: string,houseId: string) => {
  const existing = await pool.query(
    "SELECT booking_id FROM bookings WHERE tenant_id = (SELECT user_id FROM users WHERE email = $1) AND house_id = $2",
    [userEmail, houseId]
  );

  if (existing.rows.length > 0) {
    return { message: "Already rented", alreadyRented: true };
  }

  const bookingId = cuid();
  await pool.query(
    "INSERT INTO bookings (booking_id, house_id, tenant_id) VALUES ($1, $2, (SELECT user_id FROM users WHERE email = $3))",
    [bookingId, houseId, userEmail]
  );
  return { message: "House rented successfully", alreadyRented: false };
};

export const getRentsService = async (userEmail: string) => {
  const query = `
    SELECT 
      b.booking_id,
      b.status,
      b.created_at,
      h.house_id,
      h.title,
      h.description,
      h.price,
      h.latitude,
      h.longitude,
      h.image_url,
      h.landlord_email
    FROM bookings b
    JOIN houses h ON b.house_id = h.house_id
    JOIN users u ON b.tenant_id = u.user_id
    WHERE u.email = $1
    ORDER BY b.created_at DESC
  `;
  const result = await pool.query(query, [userEmail]);
  return result.rows;
};