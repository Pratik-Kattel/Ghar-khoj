// This class defines the services required to perform several actions or operations

import pool from "../config/db";
import { userData } from "../types/user";
import logger from "../config/logger";
import { hashedPassword,comparePassword } from "../utils/hash_password";
import {UserRoles} from '../types/user';
import cuid from 'cuid';
import { generate_access_token  } from "../utils/tokens";

// Service to register the new user
export const registerUserService=async({name,email,password,role}:userData)=>{
    const existingUser=await pool.query("SELECT * FROM users where email= $1",[email])
    if(existingUser.rows.length>0){
        logger.error("User with this email already exists, please login to continue");
        return null;
    }
    const hash= await hashedPassword(password);
    const id =cuid();
    const newUser= await pool.query(
        "INSERT INTO users (user_id,name,email,password_hash,role) VALUES ($1,$2,$3,$4,$5) RETURNING *",[id,name,email,hash,role || UserRoles.TENANT]
    );
    return newUser.rows[0];

}

// service to login the existing user
export const loginUserService=async({email,password}:userData)=>{
    const user=await pool.query(
        "SELECT user_id,email,password_hash,role FROM users where email=$1",[email]
    );
    if(user.rows.length===0){
        logger.error("User with this email doesn't exists, please register to continue");
        return null;
    }
    const  userData= user.rows[0];
    const isMatch=await comparePassword(password,userData.password_hash);
    if(!isMatch){
        logger.error("Wrong password please check your password and try again");
        return null;
    }
    const token=generate_access_token(userData);
    return{
        userData:{
            id:userData.id,
            email:userData.email,
            role:userData.role
        },
        token
    };

}