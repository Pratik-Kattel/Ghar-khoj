import { registerUserController,loginUserController } from "../controllers/auth_controller";
import  express  from "express";
import { saveNewPasswordController, validateEmailController, validateOTPController } from "../controllers/change_password_controller";
import { getUserDataController } from "../controllers/get_user_data_controller";
import { storeUserLocationController } from "../controllers/store_user_location_controller";
import { changeUsernameController } from "../controllers/change_user_name_controller";
import { uploadHouseController } from "../controllers/upload_house_controller";
import { getNearbyHousesController } from "../controllers/nearby_house_controller";
import { upload } from "../utils/multer";
import { getHotDealsController } from "../controllers/get_hot_deals_controller";

const router=express.Router();

router.post('/registerUser',registerUserController);
router.post('/loginUser',loginUserController);
router.post('/validateEmail',validateEmailController);
router.post('/validateOTP',validateOTPController);
router.post('/changePassword',saveNewPasswordController);
router.post('/getUsername',getUserDataController);
router.post('/storeUserLocation',storeUserLocationController);
router.post('/changeName',changeUsernameController);
router.post("/uploadHouse", upload.single("image"), uploadHouseController);
router.get('/nearbyHouses/:latitude/:longitude', getNearbyHousesController);
router.get('/hotDeals',getHotDealsController);


export default router;