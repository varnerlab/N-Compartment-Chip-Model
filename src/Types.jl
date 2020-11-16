struct Chip
    
    number_of_mixing_compartments::Int64
    number_of_input_streams::Int64
    number_of_output_streams::Int64

    function Chip(compartments=0,inputs=0,outputs=0)
        this = new(compartments,inputs,outputs)
    end
end

struct Biochemistry
end