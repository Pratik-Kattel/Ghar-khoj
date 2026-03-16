import { Request, Response } from "express";
import {
  addToWishListService,
  getWishlistService,
  checkWishlistStatusService,
} from "../service/wishlist_service";

export const addToWishListController = async (req: Request, res: Response) => {
  try {
    const { email, house_id } = req.body;
    if (!email || !house_id) {
      return res.status(400).json({ message: "email and house_id are required" });
    }
    const result = await addToWishListService(email, house_id);
    res.status(200).json(result);
  } catch (error: any) {
    res.status(400).json({ message: error.message });
  }
};

export const getWishlistController = async (req: Request, res: Response) => {
  try {
    const { userEmail } = req.params;
    const wishlist = await getWishlistService(userEmail);
    res.status(200).json({ wishlist });
  } catch (error: any) {
    res.status(500).json({ message: error.message });
  }
};

export const checkWishlistStatusController = async (
  req: Request,
  res: Response
) => {
  try {
    const { userEmail, houseId } = req.params;
    const result = await checkWishlistStatusService(userEmail, houseId);
    res.status(200).json(result);
  } catch (error: any) {
    res.status(500).json({ message: error.message });
  }
};