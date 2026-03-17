import { Request, Response } from "express";
import { addToRentsService, getRentsService } from "../service/my_rents_service";

export const addToRentsController = async (req: Request, res: Response) => {
  try {
    const { userEmail, houseId } = req.body;
    if (!userEmail || !houseId) {
      return res.status(400).json({ message: "userEmail and houseId are required" });
    }
    const result = await addToRentsService(userEmail, houseId);
    res.status(200).json(result);
  } catch (error: any) {
    res.status(500).json({ message: error.message });
  }
};

export const getRentsController = async (req: Request, res: Response) => {
  try {
    const { userEmail } = req.params;
    const rents = await getRentsService(userEmail);
    res.status(200).json({ rents });
  } catch (error: any) {
    res.status(500).json({ message: error.message });
  }
};