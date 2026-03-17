import { Request, Response } from "express";
import {addReviewService,getReviewsService,getAverageRatingService,checkReviewStatusService} from "../service/review_service";

export const addReviewController = async (req: Request, res: Response) => {
  try {
    const { houseId, tenantEmail, rating, comment } = req.body;
    if (!houseId || !tenantEmail || !rating || !comment) {
      return res.status(400).json({ message: "All fields are required" });
    }
    if (rating < 1 || rating > 5) {
      return res.status(400).json({ message: "Rating must be between 1 and 5" });
    }
    const result = await addReviewService(houseId, tenantEmail, rating, comment);
    res.status(200).json(result);
  } catch (error: any) {
    res.status(500).json({ message: error.message });
  }
};

export const getReviewsController = async (req: Request, res: Response) => {
  try {
    const { houseId } = req.params;
    const reviews = await getReviewsService(houseId);
    res.status(200).json({ reviews });
  } catch (error: any) {
    res.status(500).json({ message: error.message });
  }
};

export const getAverageRatingController = async (req: Request, res: Response) => {
  try {
    const { houseId } = req.params;
    const result = await getAverageRatingService(houseId);
    res.status(200).json(result);
  } catch (error: any) {
    res.status(500).json({ message: error.message });
  }
};

export const checkReviewStatusController = async (req: Request, res: Response) => {
  try {
    const { houseId, tenantEmail } = req.params;
    const result = await checkReviewStatusService(houseId, tenantEmail);
    res.status(200).json(result);
  } catch (error: any) {
    res.status(500).json({ message: error.message });
  }
};