use std::io::{self, Read};

fn main() {
    println!("Serverless Function: Processing input...");
    
    let mut input = String::new();
    io::stdin().read_to_string(&mut input).unwrap_or_default();
    
    let processed = if input.is_empty() {
        "No input provided".to_string()
    } else {
        format!("Processed: {} characters, {} words", 
                input.len(), 
                input.split_whitespace().count())
    };
    
    println!("{}", processed);
}
