import { Request,Response } from "express"
import { getHotDealsService } from "../service/get_hot_deals_service"
export const getHotDealsController=async(req:Request,res:Response)=>{
    try{
    const houses=await getHotDealsService();
    res.status(200).json({
        houses
    })

    }
    catch(error:any){
        res.status(400).json({message:error.message})
        }

}