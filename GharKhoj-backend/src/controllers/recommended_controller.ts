import { Request, Response } from "express";
import { getRecommendedHousesService } from "../service/recommended_service";

export const getRecommendedHousesController = async (req: Request,res: Response) => {
  try {
    const houses = await getRecommendedHousesService();
    res.status(200).json({ houses });
  } catch (error: any) {
    res.status(500).json({ message: error.message });
  }
};