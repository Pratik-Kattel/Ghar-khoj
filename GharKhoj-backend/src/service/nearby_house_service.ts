import pool from "../config/db";

export const getNearbyHousesService = async (
  latitude: number,
  longitude: number
) => {

  const query = `
  SELECT *,
  (
    6371 * acos(
      cos(radians($1)) *
      cos(radians(latitude)) *
      cos(radians(longitude) - radians($2)) +
      sin(radians($1)) *
      sin(radians(latitude))
    )
  ) AS distance
  FROM houses
  HAVING distance < 5
  ORDER BY distance;
  `;

  const result = await pool.query(query, [latitude, longitude]);

  return result.rows;
};