import pool from "../config/db";

export const getMyHousesService = async (landlordEmail: string) => {
  const query = `
    SELECT 
      h.house_id,
      h.title,
      h.description,
      h.price,
      h.latitude,
      h.longitude,
      h.image_url,
      h.created_at,
      ROUND(AVG(r.ratings)::numeric, 1) as average_rating,
      COUNT(r.review_id) as total_reviews
    FROM houses h
    LEFT JOIN reviews r ON h.house_id = r.house_id
    WHERE h.landlord_email = $1
    GROUP BY h.house_id
    ORDER BY h.created_at DESC
  `;
  const result = await pool.query(query, [landlordEmail]);
  return result.rows;
};