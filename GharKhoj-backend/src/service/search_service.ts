import pool from "../config/db";

export const searchHousesService = async (query: string,sortBy?: string) => {
  let orderClause = "ORDER BY h.created_at DESC";

  if (sortBy === "low_to_high") {
    orderClause = "ORDER BY h.price ASC";
  } else if (sortBy === "high_to_low") {
    orderClause = "ORDER BY h.price DESC";
  }

  const sql = `
    SELECT 
      h.house_id,
      h.title,
      h.description,
      h.price,
      h.latitude,
      h.longitude,
      h.image_url,
      h.landlord_email,
      ROUND(AVG(r.ratings)::numeric, 1) as average_rating,
      COUNT(r.review_id) as total_reviews
    FROM houses h
    LEFT JOIN reviews r ON h.house_id = r.house_id
    WHERE LOWER(h.title) LIKE LOWER($1)
    GROUP BY h.house_id
    ${orderClause}
  `;
  const result = await pool.query(sql, [`%${query}%`]);
  return result.rows;
};