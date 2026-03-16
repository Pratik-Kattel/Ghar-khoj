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