var OutlineFilter = function (viewWidth, viewHeight, thickness, color) {
    PIXI.AbstractFilter.call(this);

    this.uniforms = {
        thickness: {type: '1f', value: thickness},
        outlineColor: {type: '4f', value: null},
        pixelWidth: {type: '1f', value: null},
        pixelHeight: {type: '1f', value: null},
    };

    this.color = color;
    this.viewWidth = viewWidth;
    this.viewHeight = viewHeight;
    this.passes = [this];

    this.fragmentSrc = [
        'precision mediump float;',
        'varying vec2 vTextureCoord;',
        'uniform sampler2D texture;',
        'uniform float thickness;',
        'uniform vec4 outlineColor;',
        'uniform float pixelWidth;',
        'uniform float pixelHeight;',
        'vec2 px = vec2(pixelWidth, pixelHeight);',
        'void main(void) {',
        '    const float PI = 3.14159265358979323846264;',
        '    vec4 ownColor = texture2D(texture, vTextureCoord);',
        '    vec4 curColor;',
        '    float maxAlpha = 0.;',
        '    for (float angle = 0.; angle < PI * 2.; angle += ' + (1 / thickness).toFixed(7) + ') {',
        '        curColor = texture2D(texture, vec2(vTextureCoord.x + thickness * px.x * cos(angle), vTextureCoord.y + thickness * px.y * sin(angle)));',
        '        maxAlpha = max(maxAlpha, curColor.a);',
        '    }',
        '    float resultAlpha = max(maxAlpha, ownColor.a);',
        '    gl_FragColor = vec4((ownColor.rgb + outlineColor.rgb * (1. - ownColor.a)) * resultAlpha, resultAlpha);',
        '}'
    ];

    //console.log(this.fragmentSrc.join(''));
};

OutlineFilter.prototype = Object.create(PIXI.AbstractFilter.prototype);
OutlineFilter.prototype.constructor = OutlineFilter;


Object.defineProperty(OutlineFilter.prototype, 'color', {
    set: function(value) {
        var r = ((value & 0xFF0000) >> 16) / 255,
            g = ((value & 0x00FF00) >> 8) / 255,
            b = (value & 0x0000FF) / 255;
        this.uniforms.outlineColor.value = {x: r, y: g, z: b, w: 1};
        this.dirty = true;
    }
});

Object.defineProperty(OutlineFilter.prototype, 'viewWidth', {
    set: function(value) {
        this.uniforms.pixelWidth.value = 1 / value;
        this.dirty = true;
    }
});

Object.defineProperty(OutlineFilter.prototype, 'viewHeight', {
    set: function(value) {
        this.uniforms.pixelHeight.value = 1 / value;
        this.dirty = true;
    }
});

////////////////////////////////////////////////////////////////////////////////////////////////



///////////////////////////////////////////////////////////////////////////////////////////////
var OutlineFilterMultiPass = function (viewWidth, viewHeight, thickness, color) {
    PIXI.AbstractFilter.call(this);
    this.passes = [];
    this.color = color;
    this.viewWidth = viewWidth;
    this.viewHeight = viewHeight;

    var outerLayerThickness = Math.ceil(thickness / 2);

    if (thickness - outerLayerThickness > 0) {
        this.passes.push(new OutlineFilter(viewWidth, viewHeight, thickness - outerLayerThickness, color));
    }

    this.passes.push(new OutlineFilter(viewWidth, viewHeight, outerLayerThickness, color));
};

OutlineFilterMultiPass.prototype = Object.create(PIXI.AbstractFilter.prototype);
OutlineFilterMultiPass.prototype.constructor = OutlineFilterMultiPass;

Object.defineProperty(OutlineFilterMultiPass.prototype, 'color', {
    set: function(value) {
        this.passes.forEach(function (pass) {
                pass.color = value;
        });
        this.dirty = true;
    }
});

Object.defineProperty(OutlineFilterMultiPass.prototype, 'viewWidth', {
    set: function(value) {
        this.passes.forEach(function (pass) {
                pass.color = value;
        });
        this.dirty = true;
    }
});

Object.defineProperty(OutlineFilterMultiPass.prototype, 'viewHeight', {
    set: function(value) {
        this.passes.forEach(function (pass) {
                pass.color = value;
        });
        this.dirty = true;
    }
});
////////////////////////////////////////////////////////////////////////////////////////////////


var FPSCounter = function () {
    this.frameCount = 0;
    this.lastUpdate = null;
    this.value = "";
};

FPSCounter.prototype.nextFrame = function () {
    var now = new Date();

    this.frameCount++;

    if (this.lastUpdate !== null) {
        if ((now - this.lastUpdate) > 200) {
            this.value = (((200 * this.frameCount) / (now - this.lastUpdate)) * 5).toFixed(1);
            this.frameCount = 0;
            this.lastUpdate = now;
        }
    } else {
        this.lastUpdate = now;
    }
};



var stage,
    renderer,
    fpsCounter = new FPSCounter();



function init() {
    stage = new PIXI.Stage(0xFFFFFF, true);
    renderer = PIXI.autoDetectRenderer(1500, 900, null, false);
    document.body.appendChild(renderer.view);

    var
        //imageUrl = 'dotsprite.png',
        imageUrl = 'http://i.imgur.com/tyedUzX.png',
        //imageUrl = 'applesprite.png',
        //imageUrl = 'sprite.png',
        bgUrl = 'http://i.imgur.com/NPvPXtf.jpg';

    var loader = new PIXI.AssetLoader([imageUrl, bgUrl], true);

    loader.onComplete = function () {
        var bg = new PIXI.Sprite(new PIXI.Texture.fromImage(bgUrl, true));
        stage.addChild(bg);

        var sprite = new PIXI.Sprite(new PIXI.Texture.fromImage(imageUrl, true));
        sprite.position.x = 100;
        sprite.position.y = 100;

        var filter = new OutlineFilterMultiPass(renderer.width, renderer.height, 18, 0xFF0000);
        var filter2 = new OutlineFilter(sprite.texture.baseTexture.width, sprite.texture.baseTexture.height, 18, 0xFF0000);


        //this is faster, but does not work correctly when the object is smaller then the outline thickness
        sprite.shader = filter2;

        //this is slower, works correctly when the object is smaller then the outline thickness
        //sprite.filters = [filter];


        stage.addChild(sprite);

        fpsText = new PIXI.Text("fps: ", {font:"30px Arial", fill: 'red', strokeThickness: 9, dropShadow: true, dropShadowthickness: 1}),
        stage.addChild(fpsText);

        update();

    };

    loader.load();

}

function update() {
    requestAnimFrame(update);

    fpsCounter.nextFrame();
    fpsText.setText(fpsCounter.value);
    renderer.render(stage);
}

window.onload = init;