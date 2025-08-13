Shiny.addCustomMessageHandler('extract-shiny-input', extractShinyInput)

function extractShinyInput(message) {
    const inputs = document.querySelectorAll('.shiny-input-container');
    const results = [];

    inputs.forEach(function (container) {
        const inputData = extractInputData(container);
        if (inputData) {
            results.push(inputData);
        }
    });

    // submit JSON as STRING (avoids conversion to table at the shiny server)
    Shiny.setInputValue('shiny_input_json', JSON.stringify(results), {priority: 'event'});
}

function extractInputData(container) {
    const radioButtons = container.querySelectorAll('input[type="radio"]');
    
    if (radioButtons.length > 1) {
        // This is a radio group
        return extractRadioGroupData(container, radioButtons);
    } else {
        // This is a single input element
        return extractSingleInputData(container);
    }
}

function extractRadioGroupData(container, radioButtons) {
    const groupLabel = container.querySelector('label');
    const selectedRadio = Array.from(radioButtons).find(radio => radio.checked);
    
    if (!selectedRadio) {
        return null; // No selection
    }
    
    const selectedLabel = getRadioButtonLabel(selectedRadio);
    
    return {
        label: groupLabel ? groupLabel.textContent.trim() : '',
        inputId: selectedRadio.value,  // Use the value of selected radio
        value: selectedLabel           // Use the display text
    };
}

function extractSingleInputData(container) {
    const label = container.querySelector('label');
    const inputEl = container.querySelector('input, select, textarea');
    
    if (!label || !inputEl) {
        return null;
    }
    
    return {
        label: label.textContent.trim(),
        inputId: inputEl.id,
        value: getSingleInputValue(inputEl)
    };
}

function getRadioButtonLabel(radioButton) {
    // Find the span with the display text next to this radio button
    const span = radioButton.parentElement.querySelector('span');
    if (span) {
        return span.textContent.trim();
    }
    
    // Fallback to radio button value
    return radioButton.value;
}

function getSingleInputValue(inputEl) {
    const type = inputEl.type?.toLowerCase();
    
    switch (type) {
        case 'checkbox':
        case 'radio':
            return inputEl.checked;
        case 'file':
            return inputEl.files;
        case 'select-multiple':
            return Array.from(inputEl.selectedOptions || []).map(option => option.value);
        default:
            return inputEl.value;
    }
}
