<?php

namespace App\Models\Api;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class CompanyInfoModel extends Model
{
    use HasFactory;

    protected $table = "companies";


    // protected $primaryKey = 'uuid';

    // protected $hidden = ["bearer_token"];

}