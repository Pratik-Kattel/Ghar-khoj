import pool from "../config/db"

export const getHotDetailsService=async()=>{
    const houses=await pool.query("Select * from houses where price<100 ORDER BY price ASC");
    if(houses.rows.length===0){
        throw new Error("No houses found");
    }
    return houses.rows;
}