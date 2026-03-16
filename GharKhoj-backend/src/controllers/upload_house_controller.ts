import { Request, Response } from "express";
import { uploadHouseService } from "../service/upload_house_service";

export const uploadHouseController = async (req: Request, res: Response) => {
  try {

    const { title, latitude, longitude,landlord_email ,description,price} = req.body;

    const image_url = req.file?.filename;

    if (!image_url) {
      return res.status(400).json({ message: "Image is required" });
    }

    await uploadHouseService(
      title,
      Number(latitude),
      Number(longitude),
      image_url,
      landlord_email,
      description,
      price
    );

    res.status(200).json({
      message: "House uploaded successfully",
    });

  } catch (error: any) {
    res.status(500).json({
      message: error.message,
    });
  }
};