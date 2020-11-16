function evaluate_kinetics_model(t,x,data_dictionary)

    # get stuff from the data_dictionary -
    stochiometric_matrix = data_dictionary["stochiometric_matrix"]
    number_of_compartments = data_dictionary["number_of_compartments"]
    number_of_states_per_compartment = data_dictionary["number_of_states_per_compartment"]
    number_of_rates_per_compartment = data_dictionary["number_of_rates_per_compartment"]
    compartment_volume_array = data_dictionary["compartment_volume_array"]

    # what is my kinetics function pointer?
    kinetics_function_pointer = data_dictionary["kinetics_function_pointer"]

    # assemble the overall rate vector -
    overall_kinetics_vector = Array{Float64,1}()
    for compartment_index = 1:number_of_compartments
        
        # calc the rates -
        rates_in_this_compartment = kinetics_function_pointer(t,x,compartment_index,data_dictionary)
        volume = compartment_volume_array[compartment_index]
        rate_array = stochiometric_matrix*(rates_in_this_compartment*volume)

        # package -
        for value in rate_array
            push!(overall_kinetics_vector,value)
        end
    end

    # return -
    return overall_kinetics_vector
end

function evaluate_transport_model(t,x,data_dictionary)

    # get stuff from the data_dictionary -
    number_of_compartments = data_dictionary["number_of_compartments"]
    number_of_states_per_compartment = data_dictionary["number_of_states_per_compartment"]

    # what is my transport function pointer?
    transport_function_pointer = data_dictionary["transport_function_pointer"]

    # assemble transport terms -
    overall_transport_vector = Array{Float64,1}()
    for compartment_index = 1:number_of_compartments

        # calc the transport terms -
        compartment_transport_terms = transport_function_pointer(t,x,compartment_index,data_dictionary)
        for value in compartment_transport_terms
            push!(overall_transport_vector,value)
        end
    end

    # return -
    return overall_transport_vector
end

function balances(dx,x,data_dictionary,t)

    # what is my system size?
    compartment_volume_array = data_dictionary["compartment_volume_array"]
    number_of_states_per_compartment = data_dictionary["number_of_states_per_compartment"]
    number_of_compartments = data_dictionary["number_of_compartments"]
    number_of_states = number_of_states_per_compartment*number_of_compartments

    # compute mass matrix -
    mass_vector = Array{Float64,1}()
    for compartment_index = 1:number_of_compartments
        volume = compartment_volume_array[compartment_index]
        for state_index = 1:number_of_states_per_compartment
            push!(mass_vector,volume)
        end
    end
    
    # compute the transport, and kinetics terms -
    transport_terms = evaluate_transport_model(t,x,data_dictionary)
    kinetic_terms = evaluate_kinetics_model(t,x,data_dictionary)

    # compute the right hand side of the balances -
    dxdt = transport_terms + kinetic_terms

    # package -
    for index = 1:number_of_states
        dx[index] = mass_vector[index]*dxdt[index]
    end
end