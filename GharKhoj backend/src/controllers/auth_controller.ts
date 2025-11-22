import { registerUserService,loginUserService } from "../service/auth_service";
import { Request,Response } from "express";

export const registerUserController=async(req:Request,res:Response)=>{
try{
    const user=await registerUserService(req.body);
    if(!user){
        res.status(400).json({message:"User with this email already exists, please login to continue "})
    }
    res.status(201).json({message:"User created sucessfully",user});

}
catch(error){
    res.status(500).json({error:`Internal error ocurred ${error}`})

}
}

export const loginUserController=async(req:Request,res:Response)=>{
    try{
        const user=await loginUserService(req.body);
        if(!user){
            res.status(400).json({message:"Invalid credidentals"})
        };
        res.status(201).json({message:"Login successful",user})
    }
    catch(error){
        res.status(500).json({ message: "Internal server error",error });

    }
}