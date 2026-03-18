import { Request, Response } from "express";
import { getMyHousesService } from "../service/my_houses_service";

export const getMyHousesController = async (req: Request, res: Response) => {
  try {
    const { landlordEmail } = req.params;
    if (!landlordEmail) {
      return res.status(400).json({ message: "landlordEmail is required" });
    }
    const houses = await getMyHousesService(landlordEmail);
    res.status(200).json({ houses });
  } catch (error: any) {
    res.status(500).json({ message: error.message });
  }
};