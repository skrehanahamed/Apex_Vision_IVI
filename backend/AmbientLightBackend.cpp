/**
 * ==============================================================================
 * Project: Apex VISION IVI - Digital Cockpit & Infotainment System
 * File: AmbientLightBackend.cpp
 * Author / Developer: Sk Rehan Ahamed
 * License: MIT
 * ==============================================================================
 */

#include "AmbientLightBackend.h"
#include <algorithm>

AmbientLightBackend::AmbientLightBackend(QObject *parent)
    : QObject(parent)
{
    m_fadeTimer.setInterval(33); // ~30 fps smooth interpolation
    connect(&m_fadeTimer, &QTimer::timeout, this, &AmbientLightBackend::onFadeStep);
}

void AmbientLightBackend::setEnabled(bool e)
{
    if (m_enabled != e) {
        m_enabled = e;
        emit enabledChanged();
    }
}

void AmbientLightBackend::setColor(const QString &hexColor)
{
    QColor c(hexColor);
    if (c.isValid() && m_color != c) {
        m_color = c;
        emit colorChanged();
    }
}

void AmbientLightBackend::setBrightness(int b)
{
    b = std::clamp(b, 0, 100);
    if (m_brightness != b) {
        m_brightness = b;
        emit brightnessChanged();
    }
}

void AmbientLightBackend::setProfileName(const QString &name)
{
    if (m_profileName != name) {
        m_profileName = name;
        emit profileNameChanged();
    }
}

void AmbientLightBackend::fadeTo(const QString &targetHex, int targetBrightness, int durationMs)
{
    QColor dest(targetHex);
    if (!dest.isValid()) dest = m_color;

    m_startColor = m_color;
    m_endColor = dest;
    m_startBrightness = m_brightness;
    m_endBrightness = std::clamp(targetBrightness, 0, 100);
    m_fadeDurationMs = durationMs;

    m_elapsedTimer.restart();
    if (!m_fadeTimer.isActive()) {
        m_fadeTimer.start();
    }
}

void AmbientLightBackend::fadeOut(int durationMs)
{
    fadeTo(m_color.name(QColor::HexRgb), 0, durationMs);
}

void AmbientLightBackend::onFadeStep()
{
    qint64 elapsed = m_elapsedTimer.elapsed();
    if (elapsed >= m_fadeDurationMs) {
        m_fadeTimer.stop();
        m_color = m_endColor;
        m_brightness = m_endBrightness;
        emit colorChanged();
        emit brightnessChanged();
        return;
    }

    double progress = static_cast<double>(elapsed) / static_cast<double>(m_fadeDurationMs);

    // Smooth sinusoidal ease-in-out
    double eased = 0.5 * (1.0 - std::cos(progress * 3.14159265358979323846));

    int r = static_cast<int>(m_startColor.red() + (m_endColor.red() - m_startColor.red()) * eased);
    int g = static_cast<int>(m_startColor.green() + (m_endColor.green() - m_startColor.green()) * eased);
    int b = static_cast<int>(m_startColor.blue() + (m_endColor.blue() - m_startColor.blue()) * eased);

    m_color = QColor(std::clamp(r, 0, 255), std::clamp(g, 0, 255), std::clamp(b, 0, 255));
    m_brightness = static_cast<int>(m_startBrightness + (m_endBrightness - m_startBrightness) * eased);

    emit colorChanged();
    emit brightnessChanged();
}
