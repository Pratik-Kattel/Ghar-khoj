import { Request, Response } from "express";
import {createPaymentIntentService,confirmPaymentAndRentService,getBookingStatusService} from "../service/payment_service";

export const createPaymentIntentController = async (req: Request,res: Response) => {
  try {
    const { amount, currency, houseId, userEmail,startDate,endDate } = req.body;
    if (!amount || !currency || !houseId || !userEmail || !startDate || !endDate) {
      return res.status(400).json({ message: "All fields are required" });
    }
    const result = await createPaymentIntentService(
      amount,
      currency,
      houseId,
      userEmail,
      startDate,
      endDate
    );
    res.status(200).json(result);
  } catch (error: any) {
    res.status(500).json({ message: error.message });
  }
};

export const confirmPaymentController = async (req: Request,res: Response) => {
  try {
    const { paymentIntentId, houseId, userEmail,startDate,endDate } = req.body;
    if (!paymentIntentId || !houseId || !userEmail || !startDate || !endDate) {
      return res.status(400).json({ message: "All fields are required" });
    }
    const result = await confirmPaymentAndRentService(
      paymentIntentId,
      houseId,
      userEmail,
      startDate,
      endDate
    );
    res.status(200).json(result);
  } catch (error: any) {
    res.status(500).json({ message: error.message });
  }
};
export const getBookingStatusController = async (req: Request, res: Response) => {
  try {
    const { houseId } = req.params;
    const result = await getBookingStatusService(houseId);
    res.status(200).json(result);
  } catch (e: any) {
    res.status(500).json({ message: e.message });
  }
};