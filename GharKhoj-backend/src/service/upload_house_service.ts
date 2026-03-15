import pool from "../config/db";

export const uploadHouseService = async (
  title: string,
  latitude: number,
  longitude: number,
  image_url: string
) => {

  const query = `
    INSERT INTO houses(title,image_url,latitude,longitude)
    VALUES($1,$2,$3,$4)
  `;

  await pool.query(query, [title, image_url, latitude, longitude]);

};