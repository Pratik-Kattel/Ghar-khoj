import { Request,Response } from "express"
import { addWishListService,getWishlistService } from "../service/wishlist_service";
export const addWishListController=async(req:Request,res:Response)=>{
    try{
        const {email,house_id}=req.body;
        const result=await addWishListService(email,house_id);
        res.status(200).json(result);
    }
    catch(error:any){
        res.status(400).json({message:error.message});
    }
}
export const getWishlistController = async (req: Request, res: Response) => {
  try {
    const { userEmail } = req.params;
    const wishlist = await getWishlistService(userEmail);
    res.status(200).json({ wishlist });
  } catch (error: any) {
    res.status(500).json({ message: error.message });
  }
}