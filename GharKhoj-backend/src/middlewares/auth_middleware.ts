import  jwt, { JwtPayload }  from "jsonwebtoken";
import { Request,Response,NextFunction } from "express";
import { env } from "../config/env";
import { UserInfo } from "../types/user";


export const verifytoken=(req:Request,res:Response,next:NextFunction)=>{
    const jwtheader=req.headers.authorization;
    if(!jwtheader){
        return res.status(401).json({message:"No token found"});
    }
    const token=jwtheader.split(" ")[1];
    try{
       const decoded= jwt.verify(token,env.ACCESS_TOKEN_SECRET) as UserInfo
       req.user=decoded;
       next();
    }
    catch(error){
        return res.status(403).json({message:"Internal error occurred",error})

    }
}