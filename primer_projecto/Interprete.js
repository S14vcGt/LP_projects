//! Sebastian Mata. CI: 30547594. seccion 520
/**
** EBNF
** <numero>::= 0,1,2,3,4,5,6,7,8,9
** /\d/
** <variable>::= (a,b,c,..., A,B,C,...)
** /[a-zA-Z]/
** <operador>::= ^,*,-,+,=,/
** /[^*-+=/]/
** <operando>::= {<numero>} | {<variable>} | '('<O>')' | '|'<O>'|' | {<numero>}'.'{<numero>}
** 
** <O> ::= <operando>[{<operador><operando>}]
** /<operando>[<operador><operando>]+*(nada mas)/
 */

const fs= require('fs'); // invoco al modulo fylesistem
let numeros=[];  // mi conjunto de numeros aceptables 
for(let i= 0; i<=9; i++){
    numeros.push(i.toString())
};
let closure = 0;
let letras= []; // mi conjunto de letras aceptables para representar variables
for (let j=97; j<=122; j++){
    letras.push(String.fromCodePoint(j))//minusculas
};
for (let k=65; k<=90; k++){
    letras.push(String.fromCodePoint(k))//mayusculas
};
let operadores=['^','*','-','+','=','/'];
let n= 0;// numero de errores de cada linea
let counter=0; // me ayuda a controlar el valor absoluto
class Token{ 
    constructor (type, value) {
        this.type = type
        this.value = value
    }

    show(){
        return '('+this.type+', '+this.value+')';
    }
}
class analizador_lexico{// se dedica a analizar lexiacamente, elimina caracteres desconocidos 
    constructor(text){
        this.text= text.replace(/\s/g, '')
        this.pos= 0
        this.current_char = this.text[this.pos]
    }

    error(){
        n++
    }

    advance(){
        this.pos += 1
        if (this.pos > this.text.length - 1){
            this.current_char = null;
        }else{
            this.current_char = this.text[this.pos];}
    }
    
    multidigito(){ // permite tener numeros de varios caracteres
        let point =0;
        let result = '';
        while (this.current_char !=null && (numeros.includes(this.current_char) | this.current_char === '.') ){
            if (this.current_char === '.'){ 
                point ++;}
            if (point > 1){
                this.error();}
            result += this.current_char;
            this.advance();
        }
        if (result[result.length-1] === '.'){this.error()}
        return result;
    }
    
    multivariable(){
        let result = '';
        while (this.current_char !=null && letras.includes(this.current_char)){
            result += this.current_char;
            this.advance();
        }
        return result;
    }
    
    get_token(){// tokeniza cada caracter reconocible
        let streamTokens=[];
        while( this.current_char != null){
            if (numeros.includes(this.current_char)){
                streamTokens.push(new Token('NUMERO', this.multidigito()));
            }else{
                if (letras.includes(this.current_char)){
                    streamTokens.push(new Token('VARIABLE', this.multivariable()));
                }else{
                    if (operadores.includes(this.current_char)){
                        streamTokens.push(new Token('OPERADOR', this.current_char));
                        this.advance();
                    }else{
                        if (this.current_char === '('){
                            streamTokens.push(new Token('IPAREN', '('));
                            this.advance();
                        }else{
                            if (this.current_char === ')'){
                                streamTokens.push(new Token('DPAREN', ')'));
                                this.advance();
                            }else{
                                if (this.current_char=== '|'){
                                    streamTokens.push(new Token('ABS','|'));
                                    this.advance();
                                }else{// si no reconoce el caracter, marca un error y es ignorado el resto de la ejecucion
                                    this.error()
                                    this.advance();
                                }
                            }
                        }
                    } 
                }
            } 
        }
        return streamTokens;
    }
}

class interpreter{// interprete sintactico
    constructor(streamT){
        this.streamT= streamT;
        this.pos=0;
        this.current_token = this.streamT[this.pos];
    }

    error(){
        n++;
    }

    advance(){
        this.pos += 1
        if (this.pos > this.streamT.length - 1){
            this.current_token = new Token('EOF','0');// si se acaba el la linea, se marca con un token
        }else{
            this.current_token = this.streamT[this.pos];}
    }
    
    operando(){// verifica el token y devuelve un arreglo con los tokens que pueden seguirle
       let  token = this.current_token;
        if (token.type != 'EOF'){
            switch (token.type) {
                case 'NUMERO':
                    this.advance();
                    return ['OPERADOR','ABS','DPAREN'];
                case 'VARIABLE':
                    this.advance();
                    return ['OPERADOR', 'ABS','DPAREN'];
                case 'IPAREN':
                    this.advance();
                    return this.O(['NUMERO','VARIABLE','IPAREN']);
                case 'ABS':
                    this.advance()
                    if (closure > 0){
                        closure--;
                        return ['OPERADOR','DPAREN','EOF'];
                    }else{
                        closure++;
                        return this.O(['NUMERO','VARIABLE','IPAREN']);
                    }
                case 'OPERADOR':
                    this.advance();
                    return ['NUMERO','VARIABLE','IPAREN', 'ABS'];
                case 'DPAREN':
                    this.advance();
                    return ['OPERADOR','EOF', 'DPAREN', 'ABS'];
            }
        }
        return ['0'];
       
    }

    O(wait){// verifica que cada token sea seguido por el que corresponde, y si no, lanza error
        let next = wait
        while (next.includes(this.current_token.type)){
            next = this.operando();
            if(this.current_token.type === "EOF"){
                return ['0']
            }
        }
        if (!(next.includes('0')) && this.current_token.type != 'EOF'){// si no es el fin del archivo y tampoco corresponde el token, entonces hay un error
            this.error()
            this.O(this.operando())
        }
        return next
    }
}

function salida(){//*escritura en el archivo
    counter+=1;
    line= "LINEA " + counter +": ";
    if (n>0){
        line+= n + " Error(es) léxicos / de sintaxis";
    }else{
        line+="SINTAXIS OK.";
    }
    fs.appendFileSync("EVALUACION.txt", "\n"+line,(error)=>{
        console.log(error);
        console.log("fallo la escritura del archivo de salida, en la linea: "+counter);
        console.log(line);
    })
    n=0
    closure = 0;
};


try {
    const info = fs.readFileSync('EXPRESION.txt', 'utf8');
    const lines = info.split('\n');
    fs.writeFileSync("EVALUACION.txt", '', (error) =>{
        console.log(error);
        console.log('fallo la creacion del archivo de salida');
        console.log(counter);
    });
    lines.forEach(line => {
        let lexic = new analizador_lexico(line);
        let inter = new interpreter(lexic.get_token());
        if(inter.streamT.length){
            inter.O(['NUMERO','VARIABLE','IPAREN', 'ABS']);
        }
        salida();
    })
} catch (err) {
    console.error(err);
    console.error('fallo la lectura del archivo de entrada');
}