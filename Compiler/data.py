from enum import Enum

class Type(Enum):
  Stall = '00'
  Data    = '01'
  Memory  = '10'
  Control = '11'

types_dict =	{
  Type.Stall : ['nop', 'com', 'end'],  
  Type.Data : ['add', 'sub', 'and', 'or', 'mov','mod', 'cmp'],
  Type.Memory : ['ldr', 'str'],
  Type.Control : ['jmp', 'jeq']
}

opcode_dict =	{
    "nop" : '00',
    "com" : '01',
    "end" : '10',
    
    "add" : '000',
    "sub" : '001',
    "and" : '010', 
    "or"  : '011',
    "mov" : '100', 
    "mod" : '101',
    "cmp" : '110',
    
    "ldr" : '0',
    "str" : '1',
    
    "jmp" : '0',
    "jeq" : '1', 
  }
