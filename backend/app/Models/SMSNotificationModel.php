<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class SMSNotificationModel extends Model
{
    use HasFactory;

    protected $table = "sms_notifications";

    // protected $primaryKey = 'uuid';
}