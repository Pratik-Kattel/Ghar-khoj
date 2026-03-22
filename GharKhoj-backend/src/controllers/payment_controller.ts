import { Request, Response } from "express";
import {createPaymentIntentService,confirmPaymentAndRentService} from "../service/payment_service";

export const createPaymentIntentController = async (
  req: Request,
  res: Response
) => {
  try {
    const { amount, currency, houseId, userEmail } = req.body;
    if (!amount || !currency || !houseId || !userEmail) {
      return res.status(400).json({ message: "All fields are required" });
    }
    const result = await createPaymentIntentService(
      amount,
      currency,
      houseId,
      userEmail
    );
    res.status(200).json(result);
  } catch (error: any) {
    res.status(500).json({ message: error.message });
  }
};

export const confirmPaymentController = async (
  req: Request,
  res: Response
) => {
  try {
    const { paymentIntentId, houseId, userEmail } = req.body;
    if (!paymentIntentId || !houseId || !userEmail) {
      return res.status(400).json({ message: "All fields are required" });
    }
    const result = await confirmPaymentAndRentService(
      paymentIntentId,
      houseId,
      userEmail
    );
    res.status(200).json(result);
  } catch (error: any) {
    res.status(500).json({ message: error.message });
  }
};