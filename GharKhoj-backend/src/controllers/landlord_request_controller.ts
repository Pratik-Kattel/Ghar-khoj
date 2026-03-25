import { Request, Response } from "express";
import {createLandlordRequestService,getAllLandlordRequestsService,approveLandlordRequestService,rejectLandlordRequestService} from "../service/landlord_request_service";



export const createLandlordRequestController = async (req: Request, res: Response) => {
  try {
    const { email } = req.body;
    const file = req.file;

    if (!file) {
      return res.status(400).json({ message: "Citizenship image required" });
    }

    const result = await createLandlordRequestService(email, file);

    res.status(200).json({
      message: "Request submitted successfully",
      data: result
    });

  } catch (error: any) {
    res.status(400).json({ message: error.message });
  }
};


export const getAllLandlordRequestsController = async (req: Request, res: Response) => {
  try {
    const data = await getAllLandlordRequestsService();
    res.status(200).json(data);
  } catch (error: any) {
    res.status(400).json({ message: error.message });
  }
};



export const approveLandlordRequestController = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;

    const result = await approveLandlordRequestService(id);

    res.status(200).json(result);

  } catch (error: any) {
    res.status(400).json({ message: error.message });
  }
};



export const rejectLandlordRequestController = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;

    const result = await rejectLandlordRequestService(id);

    res.status(200).json(result);

  } catch (error: any) {
    res.status(400).json({ message: error.message });
  }
};