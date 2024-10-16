const showInteraction = ((data, pos, isClose, id) => {
    if (isClose) {
        let $newInteract = $(`
        <div class="main-wrapper" data-close="1" style="top: ${pos.top}px; left: ${pos.left}px">
           <div class="key-box pop-in">E</div>
            <div class="options-wrapper">
            </div>
        </div>`);
        var delay = 100;
        $('body').append($newInteract);
        for (let i in data.options) {
            let option = data.options[i];
            if (option) {
                const $newOption = $(`
                <div data-id="${id}" data-optionid="${i}" class="option-wrapper slide-right">
                    <i class="${option.icon}"></i>
                    <span>${option.label}</span>
                </div>`);
                $('.options-wrapper').append($newOption);
                $newOption.css('animation-delay', delay + 'ms');
                $newOption.on('animationend', () => {$newOption.css('width', '100%')})
                delay = delay + 100;
            }
        }
    } else {
        let $newInteract = $(`
        <div data-close="0" class="main-wrapper pop-in">
            <div class="square-box">
                <i class="${data.icon}"></i>
            </div>
        </div>`);
        $('body').append($newInteract);
    }
})

const updateInteraction = ((data, pos, isClose, id) => {
    const interactWrapper = $('.main-wrapper');
    if (interactWrapper) {
        const closeData = parseInt(interactWrapper.attr('data-close'));
        if ((closeData == false && isClose) || (closeData == true && !isClose) || data.isChanged) {
            interactWrapper.remove();
            showInteraction(data, pos, isClose, id);
        } else {
            interactWrapper.css({
                top: pos.top + 'px',
                left: pos.left + 'px'
            })
        }
    }
})

const hideInteraction = (() => {
    const interactWrapper = $('.main-wrapper');
    if (interactWrapper.length > 0) {
        const optionsWrapper = $('.options-wrapper');
        if (optionsWrapper.length > 0) {
            const allOptions = document.querySelectorAll('.options-wrapper .option-wrapper');
            allOptions.forEach(option => {
                $(option).removeClass('slide-right');
                $(option).addClass('slide-left');
                setTimeout(() => {
                    $(option).remove();
                }, 620);
            });
        }
        const keyWrapper = $('.key-box');
        keyWrapper.removeClass('pop-in');
        keyWrapper.addClass('pop-out');
        if (optionsWrapper.length > 0) {
            setTimeout(() => {
                keyWrapper.css('opacity', 0.0);
                setTimeout(() => {
                    interactWrapper.remove();
                }, 400);
            }, 450);
        } else {
            interactWrapper.remove();
        }
    }
})

const SelectOption = ((direction) => {
    const optionsWrapper = $('.options-wrapper');
    console.log(optionsWrapper.length)
    if (optionsWrapper.length > 0) {
        const selected = $('.options-wrapper').find('.selected');
        selected.removeClass('selected');

        let newSelected = direction == 'up' ? selected.prev('.option-wrapper') : selected.next('.option-wrapper');
        if (newSelected.length < 1) {
            $(`.options-wrapper .option-wrapper`).first().addClass('selected');
        } else {
            newSelected.addClass('selected');
        }
    }
})

window.addEventListener("message", (event) => {
    const data = event.data;
    switch(data.action) {
        case 'CreateInteraction':
            showInteraction(data.data, data.pos, data.isClose, data.id);
            break;
        case 'UpdateInteraction':
            updateInteraction(data.data, data.pos, data.isClose, data.id);
            break;
        case 'HideInteraction':
            hideInteraction();
            break;
        case 'SelectOption':
            SelectOption(data.direction);
            break;
        case 'ConfirmOption':
            const selected = $('.options-wrapper').find('.selected');
            console.log(selected.length)
            if (selected.length > 0) {
                console.log('send post')
                $.post('https://vs_interactions/ConfirmSelect', JSON.stringify({
                    id: selected.attr('data-id'),
                    optionId: selected.attr('data-optionid') 
                }))
            }
            break;
    }
})