import pool from "../config/db"

export const changeLandlordService=async(email:string)=>{
    const validate=await pool.query("SELECT name,role from users where email=$1",[email]);
    if(validate.rows.length===0){
        throw new Error("User with this email doesn't exists");
    }
    if(validate.rows[0].role==='LANDLORD'){
        throw new Error("User is already a landlord");
    }
await pool.query("Update users SET role='LANDLORD' where email=$1",[email]);
}