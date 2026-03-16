import { Request,Response } from "express"
import { getHotDetailsService } from "../service/get_hot_deals_service"
export const getHotDetailsController=async(req:Request,res:Response)=>{
    try{
    const houses=await getHotDetailsService();
    res.status(200).json({
        houses
    })

    }
    catch(error:any){
        res.status(400).json({message:error.message})
        }

}