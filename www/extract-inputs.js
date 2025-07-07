Shiny.addCustomMessageHandler('extract-shiny-input', extractShinyInputs)

function extractShinyInputs(message) {
    const inputs = document.querySelectorAll('.shiny-input-container');
    const results = [];

    inputs.forEach(function (input) {
        const label = input.querySelector('label');
        const inputEl = input.querySelector('input, select, textarea');

        if (label && inputEl) {
            results.push({
                label: label.textContent.trim(),
                inputId: inputEl.id,
                value: extractInputValue(inputEl)
            });
        }
    });

    // submit JSON as STRING (avoids conversion to table at the shiny server)
    Shiny.setInputValue('shiny_input_json', JSON.stringify(results), {priority: 'event'});
}

function extractInputValue(inputEl) {
    if (!inputEl) {
        return null;
    }
    
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