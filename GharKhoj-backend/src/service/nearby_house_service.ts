import pool from "../config/db";

export const getNearbyHousesService = async (latitude: number, longitude: number) => {
  const query = `
    SELECT *,
    (6371 * acos(
        LEAST(1.0, GREATEST(-1.0,
          cos(radians($1)) * cos(radians(latitude)) *
          cos(radians(longitude) - radians($2)) +
          sin(radians($1)) * sin(radians(latitude))
        ))
    )) AS distance
    FROM houses
    WHERE (6371 * acos(
        LEAST(1.0, GREATEST(-1.0,
          cos(radians($1)) * cos(radians(latitude)) *
          cos(radians(longitude) - radians($2)) +
          sin(radians($1)) * sin(radians(latitude))
        ))
    )) <= 5
    ORDER BY distance ASC
  `;
  const result = await pool.query(query, [latitude, longitude]);
  return result.rows;
};