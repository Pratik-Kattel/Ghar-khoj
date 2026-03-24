import cuid  from 'cuid';
import pool from "../config/db";

export const uploadHouseService = async (
  title: string,
  latitude: number,
  longitude: number,
  image_url: string,
  landlord_email:string,
  description:string,
  price:number
) => {
  const house_id=cuid();
  const query = `
    INSERT INTO houses(house_id,title,image_url,latitude,longitude,landlord_email,description,price)
    VALUES($1,$2,$3,$4,$5,$6,$7,$8)
  `;

  await pool.query(query, [house_id,title, image_url, latitude, longitude,landlord_email,description,price]);

};
export const updateHouseService = async (
  houseId: string,
  title: string,
  description: string,
  price: number,
) => {
  const query = `
    UPDATE houses 
    SET title=$1, description=$2, price=$3, updated_at=NOW()
    WHERE house_id=$4
  `;
  await pool.query(query, [title, description, price, houseId]);
};
export const deleteHouseService = async (houseId: string) => {

  const bookings = await pool.query(
    `SELECT booking_id FROM bookings WHERE house_id=$1`,
    [houseId]
  );
  
  const bookingIds = bookings.rows.map((b: any) => b.booking_id);

  if (bookingIds.length > 0) {
    await pool.query(
      `DELETE FROM payments WHERE booking_id = ANY($1::text[])`,
      [bookingIds]
    );
  }
  await pool.query(`DELETE FROM bookings WHERE house_id=$1`, [houseId]);


  await pool.query(`DELETE FROM reviews WHERE house_id=$1`, [houseId]);
  await pool.query(`DELETE FROM wishlists WHERE house_id=$1`, [houseId]);

  await pool.query(`DELETE FROM houses WHERE house_id=$1`, [houseId]);
};