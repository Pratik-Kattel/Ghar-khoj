import { Request, Response } from "express";
import { getNearbyHousesService } from "../service/nearby_house_service";

export const getNearbyHousesController = async (req: Request, res: Response) => {
  try {
    const latitude = parseFloat(req.params.latitude);
    const longitude = parseFloat(req.params.longitude);

    const houses = await getNearbyHousesService(latitude, longitude);

    res.status(200).json({ houses });
  } catch (error: any) {
    res.status(500).json({ message: error.message });
  }
};