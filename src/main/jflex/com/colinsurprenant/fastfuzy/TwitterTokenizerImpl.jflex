package com.colinsurprenant.fastfuzy;

/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/*

WARNING: if you change TwitterTokenizerImpl.jflex and need to regenerate
      the tokenizer, only use the trunk version of JFlex 1.5 at the moment!

*/

import org.apache.lucene.analysis.tokenattributes.CharTermAttribute;

@SuppressWarnings("fallthrough")
%%

%unicode 6.3
%integer
%final
%public
%class TwitterTokenizerImpl
%function getNextToken
%char
%buffer 255

%{

public static final int ALPHANUM          = TwitterTokenizer.ALPHANUM;
public static final int APOSTROPHE        = TwitterTokenizer.APOSTROPHE;
public static final int ACRONYM           = TwitterTokenizer.ACRONYM;
public static final int COMPANY           = TwitterTokenizer.COMPANY;
public static final int EMAIL             = TwitterTokenizer.EMAIL;
public static final int IP                = TwitterTokenizer.IP;
public static final int NUM               = TwitterTokenizer.NUM;
public static final int CJ                = TwitterTokenizer.CJ;
public static final int ACRONYM_DEP       = TwitterTokenizer.ACRONYM_DEP;
public static final int URL               = TwitterTokenizer.URL;
public static final int HASHTAG           = TwitterTokenizer.HASHTAG;
public static final int USERNAME          = TwitterTokenizer.USERNAME;
public static final int FF                = TwitterTokenizer.FF;
public static final int RT                = TwitterTokenizer.RT;
public static final int EMOTICON          = TwitterTokenizer.EMOTICON;
public static final int DASH              = TwitterTokenizer.DASH;

public static final String [] TOKEN_TYPES = TwitterTokenizer.TOKEN_TYPES;

public final int yychar()
{
    return yychar;
}

/**
 * Fills CharTermAttribute with the current token text.
 */
public final void getText(CharTermAttribute t) {
  t.copyBuffer(zzBuffer, zzStartRead, zzMarkedPos-zzStartRead);
}

/**
 * Sets the scanner buffer size in chars
 */
 public final void setBufferSize(int numChars) {

  throw new RuntimeException("setBufferSize is not (yet) supported");
//   ZZ_BUFFERSIZE = numChars;
//   char[] newZzBuffer = new char[ZZ_BUFFERSIZE];
//   System.arraycopy(zzBuffer, 0, newZzBuffer, 0, Math.min(zzBuffer.length, ZZ_BUFFERSIZE));
//   zzBuffer = newZzBuffer;
 }

%}

//THAI       = [\u0E00-\u0E59]

// basic word: a sequence of digits & letters (includes Thai to enable ThaiAnalyzer to function)
//ALPHANUM   = ({LETTER}|{THAI}|[:digit:])+

ALPHANUM  = ({LETTER}|[:digit:])* {LETTER} ({LETTER}|[:digit:])*
ALPHA      = ({LETTER})+


// internal dash: st-profond-des-creux, face-lift
// use a post-filter to remove dashes
DASH =  {ALPHA} ("-" {ALPHA})+

// internal apostrophes: O'Reilly, you're, O'Reilly's
// use a post-filter to remove possessives
APOSTROPHE =  {ALPHA} ("'" {ALPHA})+

// acronyms: U.S.A., I.B.M., etc.
// use a post-filter to remove dots
ACRONYM    =  {ALPHA} "." ({ALPHA} ".")+

//ACRONYM_DEP  = {ALPHANUM} "." ({ALPHANUM} ".")+

// company names like AT&T and Excite@Home.
COMPANY    =  {ALPHA} ("&"|"@") {ALPHA}

// email addresses
EMAIL      =  {ALPHANUM} (("."|"-"|"_") {ALPHANUM})* "@" {ALPHANUM} (("."|"-") {ALPHANUM})+

// ip address
//IP       =  [:digit:]{1,3} "." [:digit:]{1,3} "." [:digit:]{1,3} "." [:digit:]{1,3}

SLASH = "/"
NONWHITE = [^ \n\t\r]
URL = http:{SLASH}{2}({NONWHITE})+

HASHTAG = #({LETTER}|[:digit:]|"_")+
USERNAME = @({LETTER}|[:digit:]|"_")+
FF = [Ff][Ff]
RT = [Rt][Tt]

EMOTICON_SYMBOLS = (":" | ";" | "-" | "(" | ")" | "["  | "]" | "<" | ">" | "{" | "}" | "=" | "^" | "_" | "@" | "|" | "'" | "*" | "." | "^" | "/" | "\\" | "#" | "&" | "%" | "~")
EMOTICON_LETTER = ("o" | "O" | "3" | "8" | "d" | "D" | "p" | "P" | "x" | "X" | "b" | "B" | "c" | "C" | "l" | "L" | "5" | "7" | "T")
EMOTICON_ALL = ({EMOTICON_SYMBOLS}|{EMOTICON_LETTER})
HAS_EMOTICON_SYMBOLS = ({EMOTICON_ALL})* {EMOTICON_SYMBOLS} ({EMOTICON_ALL})*

EMOTICON = ({EMOTICON_ALL}*{EMOTICON_SYMBOLS}+){EMOTICON_ALL}{1,3}

// floating point, serial, model numbers, ip addresses, etc.
// every other segment must have at least one digit
//NUM        = ({ALPHANUM} {P} {HAS_DIGIT}
//           | {HAS_DIGIT} {P} {ALPHANUM}
//           | {ALPHANUM} ({P} {HAS_DIGIT} {P} {ALPHANUM})+
//           | {HAS_DIGIT} ({P} {ALPHANUM} {P} {HAS_DIGIT})+
//           | {ALPHANUM} {P} {HAS_DIGIT} ({P} {ALPHANUM} {P} {HAS_DIGIT})+
//           | {HAS_DIGIT} {P} {ALPHANUM} ({P} {HAS_DIGIT} {P} {ALPHANUM})+)

BASE_NUM = [-]? ([:digit:]+([ ][:digit:]+)*)+ ([,.] [:digit:]+)* [%KkMmBb]?
AMOUNT_NUM = "$" {BASE_NUM}
NUM = {BASE_NUM} | {AMOUNT_NUM}

// punctuation
P           = ("_"|"-"|"/"|"."|",")

// at least one digit
HAS_DIGIT  = ({LETTER}|[:digit:])* [:digit:] ({LETTER}|[:digit:])*


// From the JFlex manual: "the expression that matches everything of <a> not matched by <b> is !(!<a>|<b>)"
//LETTER     = !(![:letter:]|{CJ})
LETTER     = [:letter:]

// Chinese and Japanese (but NOT Korean, which is included in [:letter:])
//CJ         = [\u3100-\u312f\u3040-\u309F\u30A0-\u30FF\u31F0-\u31FF\u3300-\u337f\u3400-\u4dbf\u4e00-\u9fff\uf900-\ufaff\uff65-\uff9f]

WHITESPACE = \r\n | [ \r\n\t\f]

%%


//{ALPHANUM}                                                     { return ALPHANUM; }
//{APOSTROPHE}                                                   { return APOSTROPHE; }
//{ACRONYM}                                                      { return ACRONYM; }
//{COMPANY}                                                      { return COMPANY; }
//{EMAIL}                                                        { return EMAIL; }
//{HOST}                                                         { return HOST; }
//{NUM}                                                          { return NUM; }
//{CJ}                                                           { return CJ; }
//{ACRONYM_DEP}                                                  { return ACRONYM_DEP; }


{FF}                                                           { return FF; }
{RT}                                                           { return RT; }
{HASHTAG}                                                      { return HASHTAG; }
{USERNAME}                                                     { return USERNAME; }
{ALPHANUM}                                                     { return ALPHANUM; }
{APOSTROPHE}                                                   { return APOSTROPHE; }
{DASH}                                                         { return DASH; }
{ACRONYM}                                                      { return ACRONYM; }
{COMPANY}                                                      { return COMPANY; }
{EMAIL}                                                        { return EMAIL; }
//{IP}                                                           { return IP; }
{NUM}                                                          { return NUM; }
//{CJ}                                                           { return CJ; }
//{ACRONYM_DEP}                                                  { return ACRONYM_DEP; }
{URL}                                                          { return URL; }
{EMOTICON}                                                     { return EMOTICON; }

/** Ignore the rest */
. | {WHITESPACE}                                               { /* Break so we don't hit fall-through warning: */ break;/* ignore */ }
