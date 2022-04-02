<?php

namespace App\Http\Middleware;

use App\Models\Api\CompanyModel;
use Closure;
use Illuminate\Http\Request;

class BearerTokenVmsApiMiddleware
{
    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure(\Illuminate\Http\Request): (\Illuminate\Http\Response|\Illuminate\Http\RedirectResponse)  $next
     * @return \Illuminate\Http\Response|\Illuminate\Http\RedirectResponse
     */
    public function handle(Request $request, Closure $next)
    {
        $token = $request->bearerToken();


        if (is_null($token)) {
            return response()->json([
                "is_success" => False,
                "code"  => "422",
                "message" => "Authorization token required",
                "data" => NULL
            ], 200);
        }

        $company = CompanyModel::where('bearer_token', $token)->first();

        if (is_null($company)) {
            return response()->json([
                "is_success" => False,
                "code"  => "422",
                "message" => "Invalid authorization token",
                "data" => NULL
            ], 200);
        }

        $request->company_id  = $company->company_id;
        $request->company_name  = $company->name;
        $request->country_code  = $company->countryCode;

        return $next($request);
    }
}