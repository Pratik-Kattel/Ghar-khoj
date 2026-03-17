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
import { addToWishListController,getWishlistController,checkWishlistStatusController } from "../controllers/wishlist_controller";
import { addReviewController,getReviewsController,getAverageRatingController,checkReviewStatusController } from "../controllers/review_controller";
import { getRecommendedHousesController } from "../controllers/recommended_controller";

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
router.post("/addWishlist", addToWishListController);
router.get("/getWishlist/:userEmail", getWishlistController);
router.get("/checkWishlist/:userEmail/:houseId", checkWishlistStatusController);
router.post("/addReview", addReviewController);
router.get("/getReviews/:houseId", getReviewsController);
router.get("/getAverageRating/:houseId", getAverageRatingController);
router.get("/checkReview/:houseId/:tenantEmail", checkReviewStatusController);
router.get("/recommendedHouses", getRecommendedHousesController);

export default router;