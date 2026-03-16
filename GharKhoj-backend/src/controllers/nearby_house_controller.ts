import { Request, Response } from "express";
import { getNearbyHousesService } from "../service/nearby_house_service";

export const getNearbyHousesController = async (
  req: Request,
  res: Response
) => {
  try {

    const { latitude, longitude } = req.query;

    const houses = await getNearbyHousesService(
      Number(latitude),
      Number(longitude)
    );

    res.status(200).json({
      message: "Nearby houses fetched",
      houses: houses
    });

  } catch (error:any) {
    res.status(500).json({
      message: error.message
    });
  }
};