let repeatNum = "42 42 42";
let reRegex = /(\w+) \1 \1/; // Change this line
let result = reRegex.test(repeatNum);

let hello = "   Hello, World! Is nice to meet you?   ";
let wsRegex = /(\w+([.,/#!$%^&*;:{}=?\-_`~()”“"…]\s|\s))+/g; // Change this line
result = hello.match(wsRegex);
console.log(result) 