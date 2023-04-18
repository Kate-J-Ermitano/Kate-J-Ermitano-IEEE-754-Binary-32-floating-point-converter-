<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page language="java" import="java.util.*" %>
<%@ page import="java.io.File" %>
<%@ page import="java.io.FileOutputStream" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.io.IOException" %>
<!DOCTYPE html>

<html>
<head>
    <title>IEEE-754 Binary-32 floating-point converter</title>
    <link href="https://fonts.googleapis.com/css?family=Assistant:400,700&display=swap" rel="stylesheet">
    <link rel = "stylesheet" href = "design.css">
</head>

<body>
<form>
    <h3>IEEE-754 Binary-32 Floating-Point Converter (including all special cases)</h3>
    <h4>Results:</h4><br>
    <%
        try{
            // Get input from form
            float mantissa = Float.parseFloat(request.getParameter("mantissa"));
            int base = Integer.parseInt(request.getParameter("base"));
            int exponent = Integer.parseInt(request.getParameter("exponent"));
            // if decimal
            if (base == 10) {
                if(exponent > 38){
                    // display
                    // concatenate sign, expo, and frac
                    out.println("Binary: " + "0 11111111 00000000000000000000000");
                    // get HEX rep
                    out.println("HEX: " + "0x" + "7F80000");
                }
                else{
                    float og_mantissa = mantissa;
                    String mantissa_string = Double.toString(mantissa);
                    // split mantissa
                    String[] mantissa_split = mantissa_string.split("[.]");
                    if (mantissa_split[0].contains("-")) {
                        mantissa_split[0] = mantissa_split[0].replace("-", "");
                    }
                    mantissa_split[1] = "0." + mantissa_split[1];
                    // convert numerator to binary
                    String numerator = Integer.toBinaryString(Integer.parseInt(mantissa_split[0]));
                    float denominator = Float.parseFloat(mantissa_split[1]);
                    String binary_deno = ".";
                    int counter = 0;
                    // convert denominator to binary
                    while (denominator != 0.0 && counter < 17) {
                        denominator *= 2;
                        // bit is 1
                        if (Math.round(Math.floor(denominator)) == 1) {
                            binary_deno = binary_deno + "1";
                            String deno = Float.toString(denominator);
                            deno = deno.replace(deno.charAt(0), '0');
                            denominator = Float.parseFloat(deno);
                        }
                        // bit is 0
                        else if (Math.round(Math.floor(denominator)) == 0) {
                            binary_deno = binary_deno + "0";
                        }
                        counter++;
                    }
                    // combine binary numerator and denominator
                    String binary_format = numerator + binary_deno;
                    // for special cases
                    if (exponent < -38) {
                        exponent = -127;
                    }
                    mantissa = Float.parseFloat(binary_format);
                    mantissa_string = Float.toString(mantissa);
                    String sign;
                    // if mantissa is positive and greater than 1
                    if (og_mantissa >= 0 && og_mantissa >= 1) {
                        sign = "0";
                        // non-special case
                        if (exponent >= -126) {
                            // find index of string
                            int decimal_point = mantissa_string.indexOf('.');
                            // first non-zero bit
                            int first_bit = mantissa_string.indexOf('1');
                            first_bit += 1;
                            // move chars
                            int to_move = decimal_point - first_bit;
                            char[] mantissa_elements = mantissa_string.toCharArray();
                            int decimal_point_copy = decimal_point;
                            int decimal_point_before = decimal_point;
                            for (int i = 0; i < to_move; i++) {
                                decimal_point_before--;
                                char temp = mantissa_elements[decimal_point_copy];
                                mantissa_elements[decimal_point_copy] = mantissa_elements[decimal_point_before];
                                mantissa_elements[decimal_point_before] = temp;
                                decimal_point_copy--;
                            }
                            mantissa_string = new String(mantissa_elements);
                            // increment exponent
                            int to_add = decimal_point - first_bit;
                            int exponent_norm = exponent + to_add + 127;
                            // compute for exponent representation in binary
                            String binary_expo = Integer.toBinaryString(exponent_norm);
                            // append 0s if binary exponent is less than 8
                            if (binary_expo.length() < 8) {
                                int difference = 8 - binary_expo.length();
                                for (int i = 0; i < difference; i++) {
                                    binary_expo = "0" + binary_expo;
                                }
                            }
                            // compute for fractional part in binary
                            mantissa_split = mantissa_string.split("[.]");
                            // compute how many 0s to add
                            int to_add_frac = 23 - mantissa_split[1].length();
                            char[] frac_array = mantissa_split[1].toCharArray();
                            ArrayList<String> binary_frac_list = new ArrayList<>();
                            for (int i = 0; i < mantissa_split[1].length(); i++) {
                                binary_frac_list.add("" + frac_array[i]);
                            }
                            // append 0s
                            for (int i = 0; i < to_add_frac; i++) {
                                binary_frac_list.add("0");
                            }
                            String binary_frac = "";
                            // convert list to string
                            for (int i = 0; i < 23; i++) {
                                binary_frac = binary_frac + binary_frac_list.get(i);
                            }
                            // display
                            // concatenate sign, expo, and frac
                            String binary_float = sign + binary_expo + binary_frac;
                            out.println("Binary: " + sign + " " + binary_expo + " " + binary_frac);
                            // get HEX rep
                            long decimal = Long.parseLong(binary_float, 2);
                            String hex_rep = Long.toHexString(decimal);
                            out.println("HEX: " + "0x" + hex_rep);
                        }
                        // special case
                        else {
                            // determine how many places to move
                            int n = exponent + 126;
                            String append_0s = "";
                            mantissa_string = mantissa_string.replace(".", "");
                            mantissa_string = mantissa_string.replace("-", "");
                            // append 0s n times
                            for (int i = 0; i < Math.abs(n); i++) {
                                if (i == Math.abs(n) - 1) {
                                    // mantissa is negative
                                    if (mantissa < 0) {
                                        append_0s = "-0." + append_0s;
                                    } else {
                                        append_0s = "0." + append_0s;
                                    }
                                } else {
                                    append_0s = "0" + append_0s;
                                }
                            }
                            // combine
                            mantissa_string = append_0s + mantissa_string;
                            // set binary expo to 0000 0001
                            String binary_expo = "00000001";
                            // compute for fractional part in binary
                            mantissa_split = mantissa_string.split("[.]");
                            // compute how many 0s to add
                            int to_add_frac = 23 - mantissa_split[1].length();
                            char[] frac_array = mantissa_split[1].toCharArray();
                            ArrayList<String> binary_frac_list = new ArrayList<>();
                            for (int i = 0; i < mantissa_split[1].length(); i++) {
                                binary_frac_list.add("" + frac_array[i]);
                            }
                            // append 0s
                            for (int i = 0; i < to_add_frac; i++) {
                                binary_frac_list.add("0");
                            }
                            String binary_frac = "";
                            // convert list to string
                            for (int i = 0; i < 23; i++) {
                                binary_frac = binary_frac + binary_frac_list.get(i);
                            }
                            // display
                            // concatenate sign, expo, and frac
                            String binary_float = sign + binary_expo + binary_frac;
                            out.println("Binary: " + sign + " " + binary_expo + " " + binary_frac);
                            // get HEX rep
                            long decimal = Long.parseLong(binary_float, 2);
                            String hex_rep = Long.toHexString(decimal);
                            out.println("HEX: " + "0x" + hex_rep);
                        }
                    }
                    // if mantissa is positive and less than 1
                    else if (og_mantissa >= 0 && og_mantissa < 1) {
                        sign = "0";
                        // retrieve exponent from converted mantissa
                        if (mantissa_string.contains("E")) {
                            mantissa_split = mantissa_string.split("E");
                            // calculate exponent
                            int new_expo = exponent + Integer.parseInt(mantissa_split[1]);
                            int exponent_norm = new_expo + 127;
                            // get binary form of exponent
                            String binary_expo = Integer.toBinaryString(exponent_norm);
                            // append 0s if binary exponent is less than 8
                            if (binary_expo.length() < 8) {
                                int difference = 8 - binary_expo.length();
                                for (int i = 0; i < difference; i++) {
                                    binary_expo = "0" + binary_expo;
                                }
                            }
                            // get fractional part
                            String[] mantissa_split_2 = mantissa_split[0].split("[.]");
                            // compute how many 0s to add
                            int to_add_frac = 23 - mantissa_split_2[1].length();
                            char[] frac_array = mantissa_split_2[1].toCharArray();
                            ArrayList<String> binary_frac_list = new ArrayList<>();
                            for (int i = 0; i < mantissa_split_2[1].length(); i++) {
                                binary_frac_list.add("" + frac_array[i]);
                            }
                            // append 0s
                            for (int i = 0; i < to_add_frac; i++) {
                                binary_frac_list.add("0");
                            }
                            String binary_frac = "";
                            // convert list to string
                            for (int i = 0; i < 23; i++) {
                                binary_frac = binary_frac + binary_frac_list.get(i);
                            }
                            // display
                            // concatenate sign, expo, and frac
                            String binary_float = sign + binary_expo + binary_frac;
                            out.println("Binary: " + sign + " " + binary_expo + " " + binary_frac);
                            // get HEX rep
                            long decimal = Long.parseLong(binary_float, 2);
                            String hex_rep = Long.toHexString(decimal);
                            out.println("HEX: " + "0x" + hex_rep);
                        } else {
                            // calculate exponent
                            int new_expo = exponent;
                            int exponent_norm = new_expo + 127;
                            // get binary form of exponent
                            String binary_expo = Integer.toBinaryString(exponent_norm);
                            // append 0s if binary exponent is less than 8
                            if (binary_expo.length() < 8) {
                                int difference = 8 - binary_expo.length();
                                for (int i = 0; i < difference; i++) {
                                    binary_expo = "0" + binary_expo;
                                }
                            }
                            // get fractional part
                            String[] mantissa_split_2 = mantissa_string.split("[.]");
                            // compute how many 0s to add
                            int to_add_frac = 23 - mantissa_split_2[1].length();
                            char[] frac_array = mantissa_split_2[1].toCharArray();
                            ArrayList<String> binary_frac_list = new ArrayList<>();
                            for (int i = 0; i < mantissa_split_2[1].length(); i++) {
                                binary_frac_list.add("" + frac_array[i]);
                            }
                            // append 0s
                            for (int i = 0; i < to_add_frac; i++) {
                                binary_frac_list.add("0");
                            }
                            String binary_frac = "";
                            // convert list to string
                            for (int i = 0; i < 23; i++) {
                                binary_frac = binary_frac + binary_frac_list.get(i);
                            }
                            // display
                            // concatenate sign, expo, and frac
                            String binary_float = sign + binary_expo + binary_frac;
                            out.println("Binary: " + sign + " " + binary_expo + " " + binary_frac);
                            // get HEX rep
                            long decimal = Long.parseLong(binary_float, 2);
                            String hex_rep = Long.toHexString(decimal);
                            out.println("HEX: " + "0x" + hex_rep);
                        }
                    }
                    // if mantissa is negative and less than -1
                    else if (og_mantissa <= 0 && og_mantissa <= -1) {
                        sign = "1";
                        // non-special case
                        if (exponent >= -126) {
                            // find index of string
                            int decimal_point = mantissa_string.indexOf('.');
                            // first non-zero bit
                            int first_bit = mantissa_string.indexOf('1');
                            first_bit += 1;
                            // move chars
                            int to_move = decimal_point - first_bit;
                            char[] mantissa_elements = mantissa_string.toCharArray();
                            int decimal_point_copy = decimal_point;
                            int decimal_point_before = decimal_point;
                            for (int i = 0; i < to_move; i++) {
                                decimal_point_before--;
                                char temp = mantissa_elements[decimal_point_copy];
                                mantissa_elements[decimal_point_copy] = mantissa_elements[decimal_point_before];
                                mantissa_elements[decimal_point_before] = temp;
                                decimal_point_copy--;
                            }
                            mantissa_string = new String(mantissa_elements);
                            // increment exponent
                            int to_add = decimal_point - first_bit;
                            int exponent_norm = exponent + to_add + 127;
                            // compute for exponent representation in binary
                            String binary_expo = Integer.toBinaryString(exponent_norm);
                            // append 0s if binary exponent is less than 8
                            if (binary_expo.length() < 8) {
                                int difference = 8 - binary_expo.length();
                                for (int i = 0; i < difference; i++) {
                                    binary_expo = "0" + binary_expo;
                                }
                            }
                            // compute for fractional part in binary
                            mantissa_split = mantissa_string.split("[.]");
                            // compute how many 0s to add
                            int to_add_frac = 23 - mantissa_split[1].length();
                            char[] frac_array = mantissa_split[1].toCharArray();
                            ArrayList<String> binary_frac_list = new ArrayList<>();
                            for (int i = 0; i < mantissa_split[1].length(); i++) {
                                binary_frac_list.add("" + frac_array[i]);
                            }
                            // append 0s
                            for (int i = 0; i < to_add_frac; i++) {
                                binary_frac_list.add("0");
                            }
                            String binary_frac = "";
                            // convert list to string
                            for (int i = 0; i < 23; i++) {
                                binary_frac = binary_frac + binary_frac_list.get(i);
                            }
                            // display
                            // concatenate sign, expo, and frac
                            String binary_float = sign + binary_expo + binary_frac;
                            out.println("Binary: " + sign + " " + binary_expo + " " + binary_frac);
                            // get HEX rep
                            long decimal = Long.parseLong(binary_float, 2);
                            String hex_rep = Long.toHexString(decimal);
                            out.println("HEX: " + "0x" + hex_rep);
                        }
                        // special case
                        else {
                            // determine how many places to move
                            int n = exponent + 126;
                            String append_0s = "";
                            mantissa_string = mantissa_string.replace(".", "");
                            mantissa_string = mantissa_string.replace("-", "");
                            // append 0s n times
                            for (int i = 0; i < Math.abs(n); i++) {
                                if (i == Math.abs(n) - 1) {
                                    // mantissa is negative
                                    if (mantissa < 0) {
                                        append_0s = "-0." + append_0s;
                                    } else {
                                        append_0s = "0." + append_0s;
                                    }
                                } else {
                                    append_0s = "0" + append_0s;
                                }
                            }
                            // combine
                            mantissa_string = append_0s + mantissa_string;
                            // set binary expo to 0000 0001
                            String binary_expo = "00000001";
                            // compute for fractional part in binary
                            mantissa_split = mantissa_string.split("[.]");
                            // compute how many 0s to add
                            int to_add_frac = 23 - mantissa_split[1].length();
                            char[] frac_array = mantissa_split[1].toCharArray();
                            ArrayList<String> binary_frac_list = new ArrayList<>();
                            for (int i = 0; i < mantissa_split[1].length(); i++) {
                                binary_frac_list.add("" + frac_array[i]);
                            }
                            // append 0s
                            for (int i = 0; i < to_add_frac; i++) {
                                binary_frac_list.add("0");
                            }
                            String binary_frac = "";
                            // convert list to string
                            for (int i = 0; i < 23; i++) {
                                binary_frac = binary_frac + binary_frac_list.get(i);
                            }
                            /// display
                            // concatenate sign, expo, and frac
                            String binary_float = sign + binary_expo + binary_frac;
                            out.println("Binary: " + sign + " " + binary_expo + " " + binary_frac);
                            // get HEX rep
                            long decimal = Long.parseLong(binary_float, 2);
                            String hex_rep = Long.toHexString(decimal);
                            out.println("HEX: " + "0x" + hex_rep);
                        }
                    }
                    // if mantissa is negative and greater than 1
                    else if (og_mantissa <= 0 && og_mantissa > -1) {
                        sign = "1";
                        mantissa_string = mantissa_string.replace("-", "");
                        // retrieve exponent from converted mantissa
                        if (mantissa_string.contains("E")) {
                            mantissa_split = mantissa_string.split("E");
                            // calculate exponent
                            int new_expo = exponent + Integer.parseInt(mantissa_split[1]);
                            int exponent_norm = new_expo + 127;
                            // get binary form of exponent
                            String binary_expo = Integer.toBinaryString(exponent_norm);
                            // append 0s if binary exponent is less than 8
                            if (binary_expo.length() < 8) {
                                int difference = 8 - binary_expo.length();
                                for (int i = 0; i < difference; i++) {
                                    binary_expo = "0" + binary_expo;
                                }
                            }
                            // get fractional part
                            String[] mantissa_split_2 = mantissa_split[0].split("[.]");
                            // compute how many 0s to add
                            int to_add_frac = 23 - mantissa_split_2[1].length();
                            char[] frac_array = mantissa_split_2[1].toCharArray();
                            ArrayList<String> binary_frac_list = new ArrayList<>();
                            for (int i = 0; i < mantissa_split_2[1].length(); i++) {
                                binary_frac_list.add("" + frac_array[i]);
                            }
                            // append 0s
                            for (int i = 0; i < to_add_frac; i++) {
                                binary_frac_list.add("0");
                            }
                            String binary_frac = "";
                            // convert list to string
                            for (int i = 0; i < 23; i++) {
                                binary_frac = binary_frac + binary_frac_list.get(i);
                            }
                            // display
                            // concatenate sign, expo, and frac
                            String binary_float = sign + binary_expo + binary_frac;
                            out.println("Binary: " + sign + " " + binary_expo + " " + binary_frac);
                            // get HEX rep
                            long decimal = Long.parseLong(binary_float, 2);
                            String hex_rep = Long.toHexString(decimal);
                            out.println("HEX: " + "0x" + hex_rep);
                        } else {
                            // calculate exponent
                            int new_expo = exponent;
                            int exponent_norm = new_expo + 127;
                            // get binary form of exponent
                            String binary_expo = Integer.toBinaryString(exponent_norm);
                            // append 0s if binary exponent is less than 8
                            if (binary_expo.length() < 8) {
                                int difference = 8 - binary_expo.length();
                                for (int i = 0; i < difference; i++) {
                                    binary_expo = "0" + binary_expo;
                                }
                            }
                            // get fractional part
                            String[] mantissa_split_2 = mantissa_string.split("[.]");
                            // compute how many 0s to add
                            int to_add_frac = 23 - mantissa_split_2[1].length();
                            char[] frac_array = mantissa_split_2[1].toCharArray();
                            ArrayList<String> binary_frac_list = new ArrayList<>();
                            for (int i = 0; i < mantissa_split_2[1].length(); i++) {
                                binary_frac_list.add("" + frac_array[i]);
                            }
                            // append 0s
                            for (int i = 0; i < to_add_frac; i++) {
                                binary_frac_list.add("0");
                            }
                            String binary_frac = "";
                            // convert list to string
                            for (int i = 0; i < 23; i++) {
                                binary_frac = binary_frac + binary_frac_list.get(i);
                            }
                            // display
                            // concatenate sign, expo, and frac
                            String binary_float = sign + binary_expo + binary_frac;
                            out.println("Binary: " + sign + " " + binary_expo + " " + binary_frac);
                            // get HEX rep
                            long decimal = Long.parseLong(binary_float, 2);
                            String hex_rep = Long.toHexString(decimal);
                            out.println("HEX: " + "0x" + hex_rep);
                        }
                    }
                }
            }
            else if (base == 2) {
                // check if mantissa is in binary format
                // split if there is exponent in string
                String[] mantissa_split = Float.toString(mantissa).split("E");
                if ((mantissa_split[0].contains("2") || mantissa_split[0].contains("3") ||
                        mantissa_split[0].contains("4") || mantissa_split[0].contains("5") ||
                        mantissa_split[0].contains("6") || mantissa_split[0].contains("7") ||
                        mantissa_split[0].contains("8") || mantissa_split[0].contains("9"))) {
                    out.println("Not binary");
                }
                else {
                    if(exponent > 127){
                        // display
                        // concatenate sign, expo, and frac
                        out.println("Binary: " + "0 11111111 00000000000000000000000");
                        // get HEX rep
                        out.println("HEX: " + "0x" + "7F80000");
                    }
                    else{// mantissa - 100.111
                        // normalize the mantissa
                        String mantissa_string = Float.toString(mantissa);
                        String sign;
                        // if mantissa is positive and greater than 1
                        if (mantissa >= 0 && mantissa >= 1) {
                            sign = "0";
                            // non-special case
                            if (exponent >= -126) {
                                // find index of string
                                int decimal_point = mantissa_string.indexOf('.');
                                // first non-zero bit
                                int first_bit = mantissa_string.indexOf('1');
                                first_bit += 1;
                                // move chars
                                int to_move = decimal_point - first_bit;
                                char[] mantissa_elements = mantissa_string.toCharArray();
                                int decimal_point_copy = decimal_point;
                                int decimal_point_before = decimal_point;
                                for (int i = 0; i < to_move; i++) {
                                    decimal_point_before--;
                                    char temp = mantissa_elements[decimal_point_copy];
                                    mantissa_elements[decimal_point_copy] = mantissa_elements[decimal_point_before];
                                    mantissa_elements[decimal_point_before] = temp;
                                    decimal_point_copy--;
                                }
                                mantissa_string = new String(mantissa_elements);
                                // increment exponent
                                int to_add = decimal_point - first_bit;
                                int exponent_norm = exponent + to_add + 127;
                                // compute for exponent representation in binary
                                String binary_expo = Integer.toBinaryString(exponent_norm);
                                // append 0s if binary exponent is less than 8
                                if (binary_expo.length() < 8) {
                                    int difference = 8 - binary_expo.length();
                                    for (int i = 0; i < difference; i++) {
                                        binary_expo = "0" + binary_expo;
                                    }
                                }
                                // compute for fractional part in binary
                                mantissa_split = mantissa_string.split("[.]");
                                // compute how many 0s to add
                                int to_add_frac = 23 - mantissa_split[1].length();
                                char[] frac_array = mantissa_split[1].toCharArray();
                                ArrayList<String> binary_frac_list = new ArrayList<>();
                                for (int i = 0; i < mantissa_split[1].length(); i++) {
                                    binary_frac_list.add("" + frac_array[i]);
                                }
                                // append 0s
                                for (int i = 0; i < to_add_frac; i++) {
                                    binary_frac_list.add("0");
                                }
                                String binary_frac = "";
                                // convert list to string
                                for (int i = 0; i < 23; i++) {
                                    binary_frac = binary_frac + binary_frac_list.get(i);
                                }
                                // display
                                // concatenate sign, expo, and frac
                                String binary_float = sign + binary_expo + binary_frac;
                                out.println("Binary: " + sign + " " + binary_expo + " " + binary_frac);
                                // get HEX rep
                                long decimal = Long.parseLong(binary_float, 2);
                                String hex_rep = Long.toHexString(decimal);
                                out.println("HEX: " + "0x" + hex_rep);
                            }
                            // special case
                            else {
                                // determine how many places to move
                                int n = exponent + 126;
                                String append_0s = "";
                                mantissa_string = mantissa_string.replace(".", "");
                                mantissa_string = mantissa_string.replace("-", "");
                                // append 0s n times
                                for (int i = 0; i < Math.abs(n); i++) {
                                    if (i == Math.abs(n) - 1) {
                                        // mantissa is negative
                                        if (mantissa < 0) {
                                            append_0s = "-0." + append_0s;
                                        } else {
                                            append_0s = "0." + append_0s;
                                        }
                                    } else {
                                        append_0s = "0" + append_0s;
                                    }
                                }
                                // combine
                                mantissa_string = append_0s + mantissa_string;
                                // set binary expo to 0000 0001
                                String binary_expo = "00000001";
                                // compute for fractional part in binary
                                mantissa_split = mantissa_string.split("[.]");
                                // compute how many 0s to add
                                int to_add_frac = 23 - mantissa_split[1].length();
                                char[] frac_array = mantissa_split[1].toCharArray();
                                ArrayList<String> binary_frac_list = new ArrayList<>();
                                for (int i = 0; i < mantissa_split[1].length(); i++) {
                                    binary_frac_list.add("" + frac_array[i]);
                                }
                                // append 0s
                                for (int i = 0; i < to_add_frac; i++) {
                                    binary_frac_list.add("0");
                                }
                                String binary_frac = "";
                                // convert list to string
                                for (int i = 0; i < 23; i++) {
                                    binary_frac = binary_frac + binary_frac_list.get(i);
                                }
                                // display
                                // concatenate sign, expo, and frac
                                String binary_float = sign + binary_expo + binary_frac;
                                out.println("Binary: " + sign + " " + binary_expo + " " + binary_frac);
                                // get HEX rep
                                long decimal = Long.parseLong(binary_float, 2);
                                String hex_rep = Long.toHexString(decimal);
                                out.println("HEX: " + "0x" + hex_rep);
                            }
                        }
                        // if mantissa is positive and less than 1
                        else if (mantissa >= 0 && mantissa < 1) {
                            sign = "0";
                            // retrieve exponent from converted mantissa
                            if (mantissa_string.contains("E")) {
                                mantissa_split = mantissa_string.split("E");
                                // calculate exponent
                                int new_expo = exponent + Integer.parseInt(mantissa_split[1]);
                                int exponent_norm = new_expo + 127;
                                // get binary form of exponent
                                String binary_expo = Integer.toBinaryString(exponent_norm);
                                // append 0s if binary exponent is less than 8
                                if (binary_expo.length() < 8) {
                                    int difference = 8 - binary_expo.length();
                                    for (int i = 0; i < difference; i++) {
                                        binary_expo = "0" + binary_expo;
                                    }
                                }
                                // get fractional part
                                String[] mantissa_split_2 = mantissa_split[0].split("[.]");
                                // compute how many 0s to add
                                int to_add_frac = 23 - mantissa_split_2[1].length();
                                char[] frac_array = mantissa_split_2[1].toCharArray();
                                ArrayList<String> binary_frac_list = new ArrayList<>();
                                for (int i = 0; i < mantissa_split_2[1].length(); i++) {
                                    binary_frac_list.add("" + frac_array[i]);
                                }
                                // append 0s
                                for (int i = 0; i < to_add_frac; i++) {
                                    binary_frac_list.add("0");
                                }
                                String binary_frac = "";
                                // convert list to string
                                for (int i = 0; i < 23; i++) {
                                    binary_frac = binary_frac + binary_frac_list.get(i);
                                }
                                // display
                                // concatenate sign, expo, and frac
                                String binary_float = sign + binary_expo + binary_frac;
                                out.println("Binary: " + sign + " " + binary_expo + " " + binary_frac);
                                // get HEX rep
                                long decimal = Long.parseLong(binary_float, 2);
                                String hex_rep = Long.toHexString(decimal);
                                out.println("HEX: " + "0x" + hex_rep);
                            } else {
                                // calculate exponent
                                int new_expo = exponent;
                                int exponent_norm = new_expo + 127;
                                // get binary form of exponent
                                String binary_expo = Integer.toBinaryString(exponent_norm);
                                // append 0s if binary exponent is less than 8
                                if (binary_expo.length() < 8) {
                                    int difference = 8 - binary_expo.length();
                                    for (int i = 0; i < difference; i++) {
                                        binary_expo = "0" + binary_expo;
                                    }
                                }
                                // get fractional part
                                String[] mantissa_split_2 = mantissa_string.split("[.]");
                                // compute how many 0s to add
                                int to_add_frac = 23 - mantissa_split_2[1].length();
                                char[] frac_array = mantissa_split_2[1].toCharArray();
                                ArrayList<String> binary_frac_list = new ArrayList<>();
                                for (int i = 0; i < mantissa_split_2[1].length(); i++) {
                                    binary_frac_list.add("" + frac_array[i]);
                                }
                                // append 0s
                                for (int i = 0; i < to_add_frac; i++) {
                                    binary_frac_list.add("0");
                                }
                                String binary_frac = "";
                                // convert list to string
                                for (int i = 0; i < 23; i++) {
                                    binary_frac = binary_frac + binary_frac_list.get(i);
                                }
                                // display
                                // concatenate sign, expo, and frac
                                String binary_float = sign + binary_expo + binary_frac;
                                out.println("Binary: " + sign + " " + binary_expo + " " + binary_frac);
                                // get HEX rep
                                long decimal = Long.parseLong(binary_float, 2);
                                String hex_rep = Long.toHexString(decimal);
                                out.println("HEX: " + "0x" + hex_rep);
                            }
                        }
                        // if mantissa is negative and less than -1
                        else if (mantissa <= 0 && mantissa <= -1) {
                            sign = "1";
                            // non-special case
                            if (exponent >= -126) {
                                // find index of string
                                int decimal_point = mantissa_string.indexOf('.');
                                // first non-zero bit
                                int first_bit = mantissa_string.indexOf('1');
                                first_bit += 1;
                                // move chars
                                int to_move = decimal_point - first_bit;
                                char[] mantissa_elements = mantissa_string.toCharArray();
                                int decimal_point_copy = decimal_point;
                                int decimal_point_before = decimal_point;
                                for (int i = 0; i < to_move; i++) {
                                    decimal_point_before--;
                                    char temp = mantissa_elements[decimal_point_copy];
                                    mantissa_elements[decimal_point_copy] = mantissa_elements[decimal_point_before];
                                    mantissa_elements[decimal_point_before] = temp;
                                    decimal_point_copy--;
                                }
                                mantissa_string = new String(mantissa_elements);
                                // increment exponent
                                int to_add = decimal_point - first_bit;
                                int exponent_norm = exponent + to_add + 127;
                                // compute for exponent representation in binary
                                String binary_expo = Integer.toBinaryString(exponent_norm);
                                // append 0s if binary exponent is less than 8
                                if (binary_expo.length() < 8) {
                                    int difference = 8 - binary_expo.length();
                                    for (int i = 0; i < difference; i++) {
                                        binary_expo = "0" + binary_expo;
                                    }
                                }
                                // compute for fractional part in binary
                                mantissa_split = mantissa_string.split("[.]");
                                // compute how many 0s to add
                                int to_add_frac = 23 - mantissa_split[1].length();
                                char[] frac_array = mantissa_split[1].toCharArray();
                                ArrayList<String> binary_frac_list = new ArrayList<>();
                                for (int i = 0; i < mantissa_split[1].length(); i++) {
                                    binary_frac_list.add("" + frac_array[i]);
                                }
                                // append 0s
                                for (int i = 0; i < to_add_frac; i++) {
                                    binary_frac_list.add("0");
                                }
                                String binary_frac = "";
                                // convert list to string
                                for (int i = 0; i < 23; i++) {
                                    binary_frac = binary_frac + binary_frac_list.get(i);
                                }
                                // display
                                // concatenate sign, expo, and frac
                                String binary_float = sign + binary_expo + binary_frac;
                                out.println("Binary: " + sign + " " + binary_expo + " " + binary_frac);
                                // get HEX rep
                                long decimal = Long.parseLong(binary_float, 2);
                                String hex_rep = Long.toHexString(decimal);
                                out.println("HEX: " + "0x" + hex_rep);
                            }
                            // special case
                            else {
                                // determine how many places to move
                                int n = exponent + 126;
                                String append_0s = "";
                                mantissa_string = mantissa_string.replace(".", "");
                                mantissa_string = mantissa_string.replace("-", "");
                                // append 0s n times
                                for (int i = 0; i < Math.abs(n); i++) {
                                    if (i == Math.abs(n) - 1) {
                                        // mantissa is negative
                                        if (mantissa < 0) {
                                            append_0s = "-0." + append_0s;
                                        } else {
                                            append_0s = "0." + append_0s;
                                        }
                                    } else {
                                        append_0s = "0" + append_0s;
                                    }
                                }
                                // combine
                                mantissa_string = append_0s + mantissa_string;
                                // set binary expo to 0000 0001
                                String binary_expo = "00000001";
                                // compute for fractional part in binary
                                mantissa_split = mantissa_string.split("[.]");
                                // compute how many 0s to add
                                int to_add_frac = 23 - mantissa_split[1].length();
                                char[] frac_array = mantissa_split[1].toCharArray();
                                ArrayList<String> binary_frac_list = new ArrayList<>();
                                for (int i = 0; i < mantissa_split[1].length(); i++) {
                                    binary_frac_list.add("" + frac_array[i]);
                                }
                                // append 0s
                                for (int i = 0; i < to_add_frac; i++) {
                                    binary_frac_list.add("0");
                                }
                                String binary_frac = "";
                                // convert list to string
                                for (int i = 0; i < 23; i++) {
                                    binary_frac = binary_frac + binary_frac_list.get(i);
                                }
                                /// display
                                // concatenate sign, expo, and frac
                                String binary_float = sign + binary_expo + binary_frac;
                                out.println("Binary: " + sign + " " + binary_expo + " " + binary_frac);
                                // get HEX rep
                                long decimal = Long.parseLong(binary_float, 2);
                                String hex_rep = Long.toHexString(decimal);
                                out.println("HEX: " + "0x" + hex_rep);
                            }
                        }
                        // if mantissa is negative and greater than 1
                        else if (mantissa <= 0 && mantissa > -1) {
                            sign = "1";
                            // retrieve exponent from converted mantissa
                            if (mantissa_string.contains("E")) {
                                mantissa_split = mantissa_string.split("E");
                                // calculate exponent
                                int new_expo = exponent + Integer.parseInt(mantissa_split[1]);
                                int exponent_norm = new_expo + 127;
                                // get binary form of exponent
                                String binary_expo = Integer.toBinaryString(exponent_norm);
                                // append 0s if binary exponent is less than 8
                                if (binary_expo.length() < 8) {
                                    int difference = 8 - binary_expo.length();
                                    for (int i = 0; i < difference; i++) {
                                        binary_expo = "0" + binary_expo;
                                    }
                                }
                                // get fractional part
                                String[] mantissa_split_2 = mantissa_split[0].split("[.]");
                                // compute how many 0s to add
                                int to_add_frac = 23 - mantissa_split_2[1].length();
                                char[] frac_array = mantissa_split_2[1].toCharArray();
                                ArrayList<String> binary_frac_list = new ArrayList<>();
                                for (int i = 0; i < mantissa_split_2[1].length(); i++) {
                                    binary_frac_list.add("" + frac_array[i]);
                                }
                                // append 0s
                                for (int i = 0; i < to_add_frac; i++) {
                                    binary_frac_list.add("0");
                                }
                                String binary_frac = "";
                                // convert list to string
                                for (int i = 0; i < 23; i++) {
                                    binary_frac = binary_frac + binary_frac_list.get(i);
                                }
                                // display
                                // concatenate sign, expo, and frac
                                String binary_float = sign + binary_expo + binary_frac;
                                out.println("Binary: " + sign + " " + binary_expo + " " + binary_frac);
                                // get HEX rep
                                long decimal = Long.parseLong(binary_float, 2);
                                String hex_rep = Long.toHexString(decimal);
                                out.println("HEX: " + "0x" + hex_rep);
                            } else {
                                // calculate exponent
                                int new_expo = exponent;
                                int exponent_norm = new_expo + 127;
                                // get binary form of exponent
                                String binary_expo = Integer.toBinaryString(exponent_norm);
                                // append 0s if binary exponent is less than 8
                                if (binary_expo.length() < 8) {
                                    int difference = 8 - binary_expo.length();
                                    for (int i = 0; i < difference; i++) {
                                        binary_expo = "0" + binary_expo;
                                    }
                                }
                                // get fractional part
                                String[] mantissa_split_2 = mantissa_string.split("[.]");
                                // compute how many 0s to add
                                int to_add_frac = 23 - mantissa_split_2[1].length();
                                char[] frac_array = mantissa_split_2[1].toCharArray();
                                ArrayList<String> binary_frac_list = new ArrayList<>();
                                for (int i = 0; i < mantissa_split_2[1].length(); i++) {
                                    binary_frac_list.add("" + frac_array[i]);
                                }
                                // append 0s
                                for (int i = 0; i < to_add_frac; i++) {
                                    binary_frac_list.add("0");
                                }
                                String binary_frac = "";
                                // convert list to string
                                for (int i = 0; i < 23; i++) {
                                    binary_frac = binary_frac + binary_frac_list.get(i);
                                }
                                // display
                                // concatenate sign, expo, and frac
                                String binary_float = sign + binary_expo + binary_frac;
                                out.println("Binary: " + sign + " " + binary_expo + " " + binary_frac);
                                // get HEX rep
                                long decimal = Long.parseLong(binary_float, 2);
                                String hex_rep = Long.toHexString(decimal);
                                out.println("HEX: " + "0x" + hex_rep);
                            }
                        }
                    }
                }
            }
        }
        catch(Exception e){
            // display
            // concatenate sign, expo, and frac
            out.println("Binary: " + "x 1111111101xxxxxxxxxxxxxxxxxxxx");
            // get HEX rep
            out.println("HEX: " + "0x" + "xx8xxxxx");
        }
    %>
</form>
</body>
</html>
