<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Api\BranchModel;
use App\Models\Api\CategoryModel;
use App\Models\Api\CompanyInfoModel;
use App\Models\Api\CompanyModel;
use App\Models\Api\CountryModel;
use App\Models\Api\EventModel;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class OnboardingController extends Controller
{
    public function getOnboardingDetails(Request $request)
    {

        $validator = Validator::make($request->all(), [
            'company_id' => 'required',
            'company_onboarding_id' => 'required'
        ]);

        # Validating request

        if ($validator->fails()) {
            return response()->json([
                'code' => '422',
                'message' => 'Validation Error(s)',
                'data' => $validator->errors()
            ], 200);
        }


        $company_id = strtoupper($request->company_id);
        $company_onboarding_id = strtoupper($request->company_onboarding_id);

        $company = CompanyInfoModel::where('company_id', $company_id)
            ->where('onboarding_id', $company_onboarding_id)->first();




        if (!is_null($company)) {
            // $company_id = $request->company_id;
            // $company = CompanyInfoModel::where('company_id', $company_id)->get();
            // $categories = CategoryModel::where('company_id', $company_id)->get();
            // $branches = BranchModel::where('company_id', $company_id)->get();
            // $events = EventModel::where('company_id', $company_id)->get();
            // $countries = CountryModel::get();

            return response()->json([
                "code" => "000",
                "message" => "Company's details",
                "data" => $company

            ], 200);
        } else {
            return response()->json([
                "code" => "404",
                "message" => "Invalid company ID or Onboarding ID",
                "data" => null
            ], 200);
        }
    }
}