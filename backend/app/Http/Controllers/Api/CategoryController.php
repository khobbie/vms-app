<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Api\CategoryModel;
use Illuminate\Http\Request;

class CategoryController extends Controller
{
    public function getCategories(Request $request)
    {
        $company_id = $request->company_id;
        $categories = CategoryModel::where('company_id', $company_id)->get();
        return response()->json([
            "code" => "000",
            "message" => "Company's categories",
            "data" => $categories
        ], 200);
    }
}