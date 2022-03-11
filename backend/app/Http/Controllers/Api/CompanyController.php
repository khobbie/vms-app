<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Api\BranchModel;
use App\Models\Api\CategoryModel;
use App\Models\Api\CompanyModel;
use App\Models\Api\EventModel;
use Illuminate\Http\Request;
use App\Models\Api\CountryModel;

class CompanyController extends Controller
{
    public function getCompanyInfo(Request $request)
    {
        $company_id = $request->company_id;
        $company = CompanyModel::where('company_id', $company_id)->get();
        $categories = CategoryModel::where('company_id', $company_id)->get();
        $branches = BranchModel::where('company_id', $company_id)->get();
        $events = EventModel::where('company_id', $company_id)->get();
        $countries = CountryModel::get();

        return response()->json([
            "code" => "000",
            "message" => "Company's details",
            "data" => [
                "company" => $company,
                "categories" => $categories,
                "branches" => $branches,
                "events" => $events,
                "countries" => $countries
            ]
        ], 200);
    }
}