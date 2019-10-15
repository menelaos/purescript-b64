"use strict";

// Encode a Uint8Array to its Base64 representation using Node's `Buffer` API
function encodeNodeImpl (uInt8Array) {
  var base64EncodedString = Buffer.from(uInt8Array).toString("base64");

  return base64EncodedString;
};

// Decode a Base64-encoded string using Node's `Buffer` API
function decodeNodeImpl (Left, Right, str) {
  var result;

  // Check that the input string is a valid Base64-encoded string as Node.js
  // decided that it would be a good idea to NOT throw on invalid input strings
  // but return an empty buffer instead which cannot be distinguished from the
  // empty string case.
  var reEmptyString = "^$";
  var leadingQuanta = "^([A-Za-z0-9+/]{4})*";
  var finalQuantum =
    "([A-Za-z0-9+/]{4}|[A-Za-z0-9+/]{3}(?:=)?|[A-Za-z0-9+/]{2}(?:=){0,2})$";
  var reValidBase64 =
    new RegExp([reEmptyString, "|", leadingQuanta, finalQuantum].join(""));

  try {
    if (!reValidBase64.test(str)) { throw new Error("Invalid input string");}
    result = Right(Buffer.from(str, "base64"));
  }
  catch (error) {
    result = Left(error);
  }

  return result;
};

exports.encodeNodeImpl = encodeNodeImpl;
exports.decodeNodeImpl = decodeNodeImpl;
