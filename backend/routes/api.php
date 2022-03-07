<?php

use App\Http\Controllers\Api\TimeInVisitorLogApiController;
use App\Http\Controllers\Api\TimeOutVisitorLogApiController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});


Route::middleware(['BearerTokenVmsApiMiddleware'])->prefix('visitor')->group(function () {

    Route::post('/verify-check-in', [TimeInVisitorLogApiController::class, 'verifyCustomerId']);
    Route::post('/check-in', [TimeInVisitorLogApiController::class, 'checkIn']);
    Route::post('/verify-check-out', [TimeOutVisitorLogApiController::class, 'verifyCheckOut']);
    Route::post('/check-out', [TimeOutVisitorLogApiController::class, 'checkOut']);
});


// Route::domain('{account}.example.com')->group(function () {
//     Route::get('user/{id}', function ($account, $id) {

//     });
// });
