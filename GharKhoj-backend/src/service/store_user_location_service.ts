import pool from "../config/db";
import cuid from 'cuid';

export const storeUserLocationService=async(longitude:number,latitude:number,email:String)=>{
   const id=cuid();
   const location= await pool.query(`Insert into user_locations(Location_id,longitude,latitude,email,updated_at) 
      VALUES ($1,$2,$3,$4,Now())
      ON CONFLICT(email)
      DO UPDATE SET 
      latitude=EXCLUDED.latitude,
      longitude = EXCLUDED.longitude,
      updated_at = NOW()
      RETURNING *;
      `,[id,longitude,latitude,email]);
   if(location.rows.length===0){
    throw new Error("Failed to store location")
   }
   return true;
}