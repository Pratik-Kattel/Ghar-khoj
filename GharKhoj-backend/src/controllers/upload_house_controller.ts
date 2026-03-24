import { Request, Response } from "express";
import { uploadHouseService } from "../service/upload_house_service";
import { updateHouseService,deleteHouseService } from "../service/upload_house_service";

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

export const updateHouseController = async (req: Request, res: Response) => {
  try {
    const { houseId, title, description, price } = req.body;
    if (!houseId || !title || !description || !price) {
      return res.status(400).json({ message: "All fields are required" });
    }
    await updateHouseService(houseId, title, description, Number(price));
    res.status(200).json({ message: "House updated successfully" });
  } catch (error: any) {
    res.status(500).json({ message: error.message });
  }
};

export const deleteHouseController = async (req: Request, res: Response) => {
  try {
    const { houseId } = req.params;
    if (!houseId) {
      return res.status(400).json({ message: "houseId is required" });
    }
    await deleteHouseService(houseId);
    res.status(200).json({ message: "House deleted successfully" });
  } catch (error: any) {
    res.status(500).json({ message: error.message });
  }
};