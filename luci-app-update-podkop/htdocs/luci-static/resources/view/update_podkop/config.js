'use strict';
'require view';
'require form';
'require uci';
'require fs';
'require ui';

return view.extend({
    load: function() {
        return Promise.all([
            uci.load('update-podkop')
        ]);
    },

    render: function() {
        var m, s, o;

        m = new form.Map('update-podkop', _('Update Podkop Configuration'),
            _('Настройка параметров для update-podkop'));

        s = m.section(form.TypedSection, 'settings', _('Settings'));
        s.anonymous = true;
        s.addremove = false;

        o = s.option(form.Value, 'url', _('URL'),
            _('URL сервера для обновлений'));
        o.rmempty = false;
        o.placeholder = 'https://example.com/api';

        o = s.option(form.Value, 'token', _('Token'),
            _('Токен авторизации'));
        o.password = true;
        o.rmempty = false;

        // Кнопка запуска
        s = m.section(form.NamedSection, '_actions', 'actions', _('Actions'));
        s.anonymous = true;
        s.cfgsections = function() { return ['_actions']; };

        o = s.option(form.Button, '_run', _('Run Update'));
        o.inputtitle = _('Запустить update-podkop');
        o.inputstyle = 'apply';
        o.onclick = L.bind(function(ev, section_id, value) {
            var btn = ev.target;
            btn.disabled = true;
            btn.value = _('Выполняется...');

            return fs.exec('/usr/bin/update-podkop', [])
                .then(function(res) {
                    if (res.code === 0) {
                        ui.addNotification(null, 
                            E('p', _('Команда выполнена успешно')), 
                            'info');
                        
                        var output = (res.stdout || '') + (res.stderr || '');
                        if (output) {
                            ui.showModal(_('Результат выполнения'), [
                                E('pre', { 'style': 'max-height: 400px; overflow: auto;' }, 
                                    output),
                                E('div', { 'class': 'right' }, [
                                    E('button', {
                                        'class': 'btn cbi-button',
                                        'click': ui.hideModal
                                    }, _('Закрыть'))
                                ])
                            ]);
                        }
                    } else {
                        ui.addNotification(null, 
                            E('p', _('Ошибка выполнения: ') + (res.stderr || res.stdout || 'Unknown error')), 
                            'error');
                    }
                })
                .catch(function(err) {
                    ui.addNotification(null, 
                        E('p', _('Ошибка: ') + err.message), 
                        'error');
                })
                .finally(function() {
                    btn.disabled = false;
                    btn.value = _('Запустить update-podkop');
                });
        }, this);

        return m.render();
    },

    handleSaveApply: null,
    handleSave: null,
    handleReset: null
});
