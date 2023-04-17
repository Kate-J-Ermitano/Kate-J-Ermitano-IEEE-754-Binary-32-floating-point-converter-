/*
    SOURCE CODES BY: ERMITANO, KATE JUSTINE U.
    04/15/2023
*/

import java.util.*;
import java.io.*;

public class Converter {
    public static void output_to_text_file(String sign, String binary_expo, String binary_frac, String hex_rep){
        try{
            File f = new File("Results.txt");
            FileOutputStream fos = new FileOutputStream(f);
            PrintWriter pw = new PrintWriter(fos);
            String binary_format = "Binary: " + sign + " " + binary_expo + " " + binary_frac;
            String hex_format = "HEX: " + "0x" + hex_rep;
            String results = binary_format + "\n" + hex_format;
            pw.write(results);
            pw.flush();
            fos.close();
            pw.close();
            System.out.println("Output Written to file");
        }
        catch(IOException e){
            e.printStackTrace();
        }
    }
    public static void display_results(String sign, String binary_expo, String binary_frac){
        // concatenate sign, expo, and frac
        String binary_float = sign +  binary_expo + binary_frac;
        System.out.println("Binary: " + sign + " " + binary_expo + " " + binary_frac);
        // get HEX rep
        long decimal = Long.parseLong(binary_float,2);
        String hex_rep = Long.toHexString(decimal);
        System.out.println("HEX: " + "0x" + hex_rep);
        // output in text file
        Scanner scan = new Scanner(System.in);
        System.out.println("Output in text file? ");
        int response = scan.nextInt();
        if(response == 1){
            output_to_text_file(sign, binary_expo, binary_frac, hex_rep);
        }
    }
    public static void is_less_than_1(float mantissa, int base, int exponent,
                                         String mantissa_string, String sign){
        // retrieve exponent from converted mantissa
        String[] mantissa_split = mantissa_string.split("E");
        // calculate exponent
        int new_expo = exponent + Integer.parseInt(mantissa_split[1]);
        int exponent_norm = new_expo + 127;
        // get binary form of exponent
        String binary_expo = Integer.toBinaryString(exponent_norm);
        // append 0s if binary exponent is less than 8
        if(binary_expo.length() < 8){
            int difference = 8 - binary_expo.length();
            for(int i = 0; i < difference; i++){
                binary_expo = "0" + binary_expo;
            }
        }
        // get fractional part
        String[] mantissa_split_2 = mantissa_split[0].split("[.]");
        // compute how many 0s to add
        int to_add_frac = 23 - mantissa_split_2[1].length();
        char[] frac_array = mantissa_split_2[1].toCharArray();
        ArrayList<String> binary_frac_list = new ArrayList<>();
        for(int i = 0; i < mantissa_split_2[1].length(); i++){
            binary_frac_list.add("" + frac_array[i]);
        }
        // append 0s
        for(int i = 0; i < to_add_frac; i++){
            binary_frac_list.add("0");
        }
        String binary_frac = "";
        // convert list to string
        for(int i = 0; i < 23; i++){
            binary_frac = binary_frac + binary_frac_list.get(i);
        }
        // display
        display_results(sign, binary_expo, binary_frac);
    }
    public static void is_greater_than_1(float mantissa, int base, int exponent,
                                         String mantissa_string, String sign){
        // non-special case
        if(exponent >= -126){
            // find index of string
            int decimal_point = mantissa_string.indexOf('.');
            // first non-zero bit
            int first_bit = mantissa_string.indexOf('1');
            first_bit+=1;
            // move chars
            int to_move = decimal_point - first_bit;
            char[] mantissa_elements = mantissa_string.toCharArray();
            int decimal_point_copy = decimal_point;
            int decimal_point_before = decimal_point;
            for(int i = 0; i < to_move; i++){
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
            if(binary_expo.length() < 8){
                int difference = 8 - binary_expo.length();
                for(int i = 0; i < difference; i++){
                    binary_expo = "0" + binary_expo;
                }
            }
            // compute for fractional part in binary
            String[] mantissa_split = mantissa_string.split("[.]");
            // compute how many 0s to add
            int to_add_frac = 23 - mantissa_split[1].length();
            char[] frac_array = mantissa_split[1].toCharArray();
            ArrayList<String> binary_frac_list = new ArrayList<>();
            for(int i = 0; i < mantissa_split[1].length(); i++){
                binary_frac_list.add("" + frac_array[i]);
            }
            // append 0s
            for(int i = 0; i < to_add_frac; i++){
                binary_frac_list.add("0");
            }
            String binary_frac = "";
            // convert list to string
            for(int i = 0; i < 23; i++){
                binary_frac = binary_frac + binary_frac_list.get(i);
            }
            // display
            display_results(sign, binary_expo, binary_frac);
        }
        // special case
        else{
            // determine how many places to move
            int n = exponent + 126;
            String append_0s = "";
            mantissa_string = mantissa_string.replace(".", "");
            mantissa_string = mantissa_string.replace("-", "");
            // append 0s n times
            for(int i = 0; i < Math.abs(n); i++){
                if(i == Math.abs(n) - 1){
                    // mantissa is negative
                    if(mantissa < 0){
                        append_0s = "-0." + append_0s;
                    }
                    else{
                        append_0s = "0." + append_0s;
                    }
                }
                else{
                    append_0s = "0" + append_0s;
                }
            }
            // combine
            mantissa_string = append_0s + mantissa_string;
            System.out.println(mantissa_string);
            // set binary expo to 0000 0001
            String binary_expo = "00000001";
            // compute for fractional part in binary
            String[] mantissa_split = mantissa_string.split("[.]");
            // compute how many 0s to add
            int to_add_frac = 23 - mantissa_split[1].length();
            char[] frac_array = mantissa_split[1].toCharArray();
            ArrayList<String> binary_frac_list = new ArrayList<>();
            for(int i = 0; i < mantissa_split[1].length(); i++){
                binary_frac_list.add("" + frac_array[i]);
            }
            // append 0s
            for(int i = 0; i < to_add_frac; i++){
                binary_frac_list.add("0");
            }
            String binary_frac = "";
            // convert list to string
            for(int i = 0; i < 23; i++){
                binary_frac = binary_frac + binary_frac_list.get(i);
            }
            // display
            display_results(sign, binary_expo, binary_frac);
        }
    }
    public static void is_binary(float mantissa, int base, int exponent){
        // mantissa - 100.111
        // normalize the mantissa
        String mantissa_string = Float.toString(mantissa);
        String sign;
        // if mantissa is positive and greater than 1
        if(mantissa >= 0 && mantissa >= 1){
            sign = "0";
            is_greater_than_1(mantissa, base, exponent, mantissa_string, sign);
        }
        // if mantissa is positive and less than 1
        else if(mantissa >= 0 && mantissa < 1){
            sign = "0";
            is_less_than_1(mantissa, base, exponent, mantissa_string, sign);
        }
        // if mantissa is negative and less than -1
        else if(mantissa <= 0 && mantissa <= -1){
            sign = "1";
            is_greater_than_1(mantissa, base, exponent, mantissa_string, sign);
        }
        // if mantissa is negative and greater than 11
        else if(mantissa <= 0 && mantissa > -1){
            sign = "1";
            is_less_than_1(mantissa, base, exponent, mantissa_string, sign);
        }
    }
    public static void convertToBinary(float mantissa, int base, int exponent){
        String mantissa_string = Float.toString(mantissa);
        // split mantissa
        String[] mantissa_split = mantissa_string.split("[.]");
        mantissa_split[1] = "0." + mantissa_split[1];
        // convert numerator to binary
        String numerator = Integer.toBinaryString(Integer.parseInt(mantissa_split[0]));
        float denominator = Float.parseFloat(mantissa_split[1]);
        String binary_deno = ".";
        int counter = 0;
        // convert denominator to binary
        while(denominator != 0.0 && counter < 17){
            System.out.println(denominator);
            denominator *= 2;
            // bit is 1
            if(Math.round(Math.floor(denominator)) == 1){
                binary_deno = binary_deno + "1";
                String deno = Float.toString(denominator);
                deno = deno.replace(deno.charAt(0), '0');
                denominator = Float.parseFloat(deno);
            }
            // bit is 0
            else if(Math.round(Math.floor(denominator)) == 0){
                binary_deno = binary_deno + "0";
            }
            counter++;
        }
        // combine binary numerator and denominator
        String binary_format = numerator + binary_deno;
        // for special cases
        if(exponent < -38){
            exponent = -127;
        }
        System.out.println(binary_format);
        // convert to floating point
        is_binary(Float.parseFloat(binary_format), base, exponent);
    }
    public static String initiate(){
        return "Test";
    }
}
